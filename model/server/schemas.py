from typing import Any, Dict, List, Literal, Optional
from pydantic import BaseModel


class ModelInfo(BaseModel):
    last_trained_date: str
    model_filename: str
    training_rows: int
    trained_at: str


class JobStatus(BaseModel):
    job_id: str
    type: str
    status: Literal["pending", "running", "done", "error"]
    message: str
    result: Optional[Any] = None


class PredictRequest(BaseModel):
    months: int = 3

    model_config = {
        "json_schema_extra": {"example": {"months": 3}}
    }
