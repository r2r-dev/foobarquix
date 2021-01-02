from pydantic import BaseModel


class ReadyResponse(BaseModel):
    status: str
