from pydantic import BaseModel


class AddNumbersRequest(BaseModel):
    """
    Request to add 2 numbers.
    """
    a: int
    b: int
    message: str = "I added the numbers."
