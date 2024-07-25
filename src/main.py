import os
from fastapi import FastAPI

from api.v1 import router

stage = os.getenv("STAGE_NAME")
stage_pref = ("/%s" % stage) if stage else ""

app = FastAPI(
    title="FastAPI Example App",
    docs_url="/docs",
    root_path=stage_pref,
    redoc_url=None
)

app.include_router(router, prefix=stage_pref + "/api")
