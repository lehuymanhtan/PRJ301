import threading
import uuid
from datetime import datetime

import pandas as pd
from fastapi import APIRouter, File, HTTPException, UploadFile

from server.core import job_store, prophet_utils
from server.schemas import JobStatus

router = APIRouter(prefix="/retrain", tags=["Retrain"])


# ── Background worker ─────────────────────────────────────────
def _run_retrain(job_id: str, csv_bytes: bytes) -> None:
    try:
        job_store.update(job_id, status="running", message="Loading and merging data …")

        df_current = prophet_utils.get_current_data()
        df_new     = prophet_utils.load_csv_bytes(csv_bytes)

        df_all = (
            pd.concat([df_current, df_new], ignore_index=True)
            .drop_duplicates(subset="ds")
            .sort_values("ds")
            .reset_index(drop=True)
        )

        last_date = df_all["ds"].max().strftime("%Y-%m-%d")
        rows      = len(df_all)

        job_store.update(job_id, message=f"Fitting Prophet model on {rows} rows …")

        m = prophet_utils.build_model()
        m.fit(df_all)

        # Save model under trained_models/{last_date}/
        model_rel  = f"trained_models/{last_date}/prophet_model.json"
        model_path = prophet_utils.BASE_DIR / model_rel
        prophet_utils.save_model(m, model_path)

        # Persist the merged dataset (raw VNĐ, no header) for future retrains
        df_save = df_all[["ds", "y"]].copy()
        df_save["y"]  = (df_save["y"] * 1e9).round(0).astype("int64")
        df_save["ds"] = df_save["ds"].dt.strftime("%Y-%m-%d")
        df_save.to_csv(prophet_utils.CURRENT_DATA, header=False, index=False)

        # Update metadata so /model/info and /predict see the new model
        meta = {
            "last_trained_date": last_date,
            "model_filename":    model_rel,
            "training_rows":     rows,
            "trained_at":        datetime.now().isoformat(),
        }
        prophet_utils.save_metadata(meta)

        job_store.update(
            job_id,
            status="done",
            message=f"Retrain complete. Model saved for {last_date}.",
            result={
                "last_trained_date": last_date,
                "model_filename":    model_rel,
                "training_rows":     rows,
            },
        )

    except Exception as exc:
        job_store.update(job_id, status="error", message=str(exc))


# ── Endpoint ──────────────────────────────────────────────────
@router.post(
    "",
    response_model=JobStatus,
    status_code=202,
    summary="Retrain model with new data",
    description="""
Upload a **CSV file** (no header) with two columns:
- Column 1 – date in `YYYY-MM-DD` format
- Column 2 – daily revenue as a **raw integer** (same unit as `data.csv`)

The new data is **merged with the existing history** (duplicates removed by date),
a fresh Prophet model is fitted, and saved under:

```
trained_models/{last_date_of_data}/prophet_model.json
```

`/model/info` and future `/predict` calls will automatically use the new model.

Returns a `job_id` immediately. Poll `GET /jobs/{job_id}` for progress.
""",
)
async def retrain(
    file: UploadFile = File(..., description="CSV (no header): date, daily_revenue"),
) -> JobStatus:
    if not file.filename.lower().endswith(".csv"):
        raise HTTPException(status_code=400, detail="Only .csv files are accepted.")

    content = await file.read()
    job_id  = str(uuid.uuid4())
    job     = job_store.create(job_id, "retrain")

    thread = threading.Thread(target=_run_retrain, args=(job_id, content), daemon=True)
    thread.start()

    return JobStatus(**job)
