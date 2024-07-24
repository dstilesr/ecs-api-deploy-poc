import os
from fastapi import FastAPI

from api.v1 import router

stage = os.getenv("STAGE_NAME")

app = FastAPI(
    title="FastAPI Example App",
    docs_url="/docs",
    root_path=("/%s" % stage) if stage else "",
    redoc_url=None
)

app.include_router(router, prefix="/api")
