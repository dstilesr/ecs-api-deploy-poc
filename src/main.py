import os
from mangum import Mangum
from fastapi import FastAPI

from api.v1 import router


app = FastAPI(
    title="Mangum Example App",
    docs_url="/api-docs/docs",
    openapi_url="/api-docs/openapi.json",
    root_path="/%s" % os.getenv("STAGE_NAME", ""),
    redoc_url=None
)

app.include_router(router, prefix="/api")

lambda_handler = Mangum(app, lifespan="off")
