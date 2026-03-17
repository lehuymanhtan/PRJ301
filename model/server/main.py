"""
Prophet Revenue Forecast – Local API Server
============================================
Start:  uvicorn server.main:app --reload --port 8000
Docs:   http://localhost:8000/docs   (Swagger UI)
        http://localhost:8000/redoc  (ReDoc)
"""
from contextlib import asynccontextmanager

from fastapi import FastAPI, HTTPException
from fastapi.responses import RedirectResponse

from server.core import job_store, prophet_utils
from server.routers import info, predict, retrain
from server.schemas import JobStatus


# ── Lifespan (replaces deprecated @app.on_event) ──────────────
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Bootstrap model_metadata.json on first run
    prophet_utils.get_metadata()
    yield


# ── App ────────────────────────────────────────────────────────
app = FastAPI(
    title="Prophet Revenue Forecast API",
    description="""
A local API server for daily revenue forecasting using **Facebook Prophet**.

## Quick workflow

1. `GET  /model/info`       → check what data the model was last trained on
2. `POST /retrain`          → upload new CSV data to retrain the model
3. `POST /predict`          → generate a forecast for the next N months
4. `GET  /jobs/{job_id}`    → poll for job progress

## Async jobs

`/retrain` and `/predict` are **non-blocking** — they return a `job_id` immediately
and run in the background. Poll `GET /jobs/{job_id}` until `status` is `"done"` or `"error"`.

## Output files

All prediction outputs (charts + CSVs) are saved to `outputs/predict_{short_id}/` on disk.
The exact path is returned in `result.output_folder` when the job is done.
""",
    version="1.0.0",
    lifespan=lifespan,
)

# ── Routers ───────────────────────────────────────────────────
app.include_router(info.router)
app.include_router(retrain.router)
app.include_router(predict.router)


# ── Job endpoints ─────────────────────────────────────────────
@app.get(
    "/jobs/{job_id}",
    response_model=JobStatus,
    tags=["Jobs"],
    summary="Get job status",
    description=(
        "Poll this endpoint to track the progress of an async **retrain** or **predict** job. "
        "Possible `status` values: `pending` → `running` → `done` | `error`. "
        "When `status` is `done`, the `result` field contains the output details."
    ),
)
def get_job(job_id: str) -> JobStatus:
    job = job_store.get(job_id)
    if not job:
        raise HTTPException(status_code=404, detail=f"Job '{job_id}' not found.")
    return JobStatus(**job)


@app.get(
    "/jobs",
    response_model=list[JobStatus],
    tags=["Jobs"],
    summary="List all jobs",
    description=(
        "Returns all jobs submitted in the **current server session**. "
        "The job list is in-memory and resets on server restart."
    ),
)
def list_jobs() -> list[JobStatus]:
    return [JobStatus(**j) for j in job_store.list_all()]


# ── Root ──────────────────────────────────────────────────────
@app.get("/", include_in_schema=False)
def root():
    return RedirectResponse(url="/docs")
