import threading
import uuid
from pathlib import Path

import pandas as pd
from fastapi import APIRouter

from server.core import job_store, prophet_utils
from server.schemas import JobStatus, PredictRequest

router = APIRouter(prefix="/predict", tags=["Predict"])


# ── Background worker ─────────────────────────────────────────
def _run_predict(job_id: str, months: int, output_dir: Path) -> None:
    try:
        job_store.update(job_id, status="running", message="Loading model …")

        m    = prophet_utils.load_model()
        meta = prophet_utils.get_metadata()
        last_date = pd.Timestamp(meta["last_trained_date"])

        job_store.update(job_id, message=f"Forecasting {months} months ahead …")

        future   = m.make_future_dataframe(periods=months * 31, freq="D")
        forecast = m.predict(future)

        # Trim to exactly N calendar months after training end
        fcast  = forecast[forecast["ds"] > last_date].copy()
        cutoff = last_date + pd.DateOffset(months=months)
        fcast  = fcast[fcast["ds"] < cutoff].copy()

        for col in ["yhat", "yhat_lower", "yhat_upper"]:
            fcast[col] = fcast[col].clip(lower=0)

        # ── Aggregate ────────────────────────────────────────
        AGG = {"yhat": "sum", "yhat_lower": "sum", "yhat_upper": "sum"}

        monthly = (
            fcast.groupby(fcast["ds"].dt.to_period("M"), sort=True)
            .agg(AGG).reset_index()
            .rename(columns={"ds": "Tháng", "yhat": "Dự báo (tỷ)",
                             "yhat_lower": "Lower 95%", "yhat_upper": "Upper 95%"})
        )
        quarterly = (
            fcast.groupby(fcast["ds"].dt.to_period("Q"), sort=True)
            .agg(AGG).reset_index()
            .rename(columns={"ds": "Quý", "yhat": "Dự báo (tỷ)",
                             "yhat_lower": "Lower 95%", "yhat_upper": "Upper 95%"})
        )

        fcast_yr = fcast.copy()
        fcast_yr["year"] = fcast_yr["ds"].dt.year
        yearly = (
            fcast_yr.groupby("year", sort=True)
            .agg(AGG).reset_index()
            .rename(columns={"year": "Năm", "yhat": "Dự báo (tỷ)",
                             "yhat_lower": "Lower 95%", "yhat_upper": "Upper 95%"})
        )

        total    = fcast["yhat"].sum()
        total_lo = fcast["yhat_lower"].sum()
        total_hi = fcast["yhat_upper"].sum()

        # ── Save output ──────────────────────────────────────
        job_store.update(job_id, message="Saving output files …")
        output_dir.mkdir(parents=True, exist_ok=True)

        # CSVs
        fcast[["ds", "yhat", "yhat_lower", "yhat_upper"]].to_csv(
            output_dir / "forecast_daily.csv", index=False
        )
        monthly_out = monthly.copy()
        monthly_out["Tháng"] = monthly_out["Tháng"].astype(str)
        monthly_out.to_csv(output_dir / "forecast_monthly.csv", index=False)

        quarterly_out = quarterly.copy()
        quarterly_out["Quý"] = quarterly_out["Quý"].astype(str)
        quarterly_out.to_csv(output_dir / "forecast_quarterly.csv", index=False)

        yearly.to_csv(output_dir / "forecast_yearly.csv", index=False)

        # Charts
        prophet_utils.save_plots(m, forecast, output_dir, last_date)
        prophet_utils.save_monthly_bar(monthly, total, total_lo, total_hi, output_dir)

        # ── Build result ─────────────────────────────────────
        result = {
            "output_folder": str(output_dir),
            "files": [
                "forecast_daily.csv",
                "forecast_monthly.csv",
                "forecast_quarterly.csv",
                "forecast_yearly.csv",
                "forecast_plot.png",
                "components_plot.png",
                "monthly_bar.png",
            ],
            "summary": {
                "forecast_start":  (last_date + pd.Timedelta(days=1)).strftime("%Y-%m-%d"),
                "forecast_end":    (cutoff - pd.Timedelta(days=1)).strftime("%Y-%m-%d"),
                "months_requested": months,
                "total_ty_vnd":    round(total, 2),
                "lower_95":        round(total_lo, 2),
                "upper_95":        round(total_hi, 2),
                "by_month": [
                    {
                        "month":    str(r["Tháng"]),
                        "forecast": round(r["Dự báo (tỷ)"], 2),
                        "lower":    round(r["Lower 95%"], 2),
                        "upper":    round(r["Upper 95%"], 2),
                    }
                    for _, r in monthly.iterrows()
                ],
            },
        }

        job_store.update(job_id, status="done", message="Prediction complete.", result=result)

    except Exception as exc:
        job_store.update(job_id, status="error", message=str(exc))


# ── Endpoint ──────────────────────────────────────────────────
@router.post(
    "",
    response_model=JobStatus,
    status_code=202,
    summary="Start a revenue forecast",
    description="""
Loads the **current Prophet model** and generates a forecast for the next **N months**
(default `3`). Runs in the background.

Poll `GET /jobs/{job_id}` until `status` is `"done"` or `"error"`.

When done, `result.output_folder` contains all generated files:

| File | Description |
|---|---|
| `forecast_daily.csv` | Day-level predictions with confidence interval |
| `forecast_monthly.csv` | Monthly aggregated totals |
| `forecast_quarterly.csv` | Quarterly aggregated totals |
| `forecast_yearly.csv` | Yearly aggregated totals |
| `forecast_plot.png` | Full timeline chart |
| `components_plot.png` | Trend / holiday / seasonality breakdown |
| `monthly_bar.png` | Bar chart of monthly totals |

`result.summary` also returns a JSON summary of the totals so you don't need to open files just for key numbers.
""",
)
def predict(body: PredictRequest = None) -> JobStatus:
    if body is None:
        body = PredictRequest()

    job_id     = str(uuid.uuid4())
    short_id   = job_id[:8]
    output_dir = prophet_utils.OUTPUTS_DIR / f"predict_{short_id}"

    job = job_store.create(job_id, "predict")

    thread = threading.Thread(
        target=_run_predict, args=(job_id, body.months, output_dir), daemon=True
    )
    thread.start()

    return JobStatus(**job)
