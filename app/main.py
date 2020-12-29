from fastapi import FastAPI

from app.api.routes.api import router as api_router
from app.core.config import DEBUG
from app.core.config import PROJECT_NAME
from app.core.config import VERSION


def get_application() -> FastAPI:
    application = FastAPI(title=PROJECT_NAME, debug=DEBUG, version=VERSION)

    application.include_router(api_router)

    return application


app = get_application()

