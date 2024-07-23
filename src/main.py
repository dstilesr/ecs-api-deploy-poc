import os
from fastapi import FastAPI

from api.v1 import router


app = FastAPI(
    title="FastAPI Example App",
    docs_url="/docs",
    root_path="/%s" % os.getenv("STAGE_NAME", ""),
    redoc_url=None
)

app.include_router(router, prefix="/api")
