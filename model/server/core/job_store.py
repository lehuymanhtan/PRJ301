"""
Thread-safe in-memory store for background job status.
Resets on server restart (intentional for a local server).
"""
import threading
from typing import Any, Dict, List, Optional

_jobs: Dict[str, Dict[str, Any]] = {}
_lock = threading.Lock()


def create(job_id: str, job_type: str) -> Dict[str, Any]:
    job = {
        "job_id": job_id,
        "type": job_type,
        "status": "pending",
        "message": "Queued, waiting to start",
        "result": None,
    }
    with _lock:
        _jobs[job_id] = job
    return dict(job)


def update(job_id: str, **kwargs) -> None:
    with _lock:
        if job_id in _jobs:
            _jobs[job_id].update(kwargs)


def get(job_id: str) -> Optional[Dict[str, Any]]:
    with _lock:
        job = _jobs.get(job_id)
        return dict(job) if job else None


def list_all() -> List[Dict[str, Any]]:
    with _lock:
        return [dict(j) for j in _jobs.values()]
