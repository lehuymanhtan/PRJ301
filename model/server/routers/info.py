from fastapi import APIRouter
from server.core import prophet_utils
from server.schemas import ModelInfo

router = APIRouter(prefix="/model", tags=["Model Info"])


@router.get(
    "/info",
    response_model=ModelInfo,
    summary="Get current model info",
    description=(
        "Returns metadata about the currently loaded Prophet model: "
        "the **last date it was trained on**, the model file path, "
        "the number of training rows, and the timestamp it was trained."
    ),
)
def model_info() -> ModelInfo:
    meta = prophet_utils.get_metadata()
    return ModelInfo(**meta)
