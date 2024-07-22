from fastapi import APIRouter
from fastapi.responses import JSONResponse

from .models import AddNumbersRequest

router = APIRouter(prefix="/v1")


@router.get("/add-numbers")
async def add_numbers(a: int, b: int) -> JSONResponse:
    """
    Just add 2 numbers as an example.
    :param a: Number
    :param b: Other Number
    :return:
        Keys
        ----
        - result
        - message
    """
    result = a + b
    return JSONResponse(
        {"result": result, "message": "I added the numbers."}
    )


@router.post("/add-numbers")
async def add_numbers_post(req: AddNumbersRequest) -> JSONResponse:
    """
    Add 2 numbers as an example, with a post request.
    :param req: JSON Request
        Keys
        ----
        - a
        - b
        - message (optional)
    :return:
    """
    result = req.a + req.b
    return JSONResponse(
        {"result": result, "message": req.message}
    )
