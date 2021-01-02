from fastapi import FastAPI

from app.api.routes.api import router as api_router
from app.core.config import DEBUG, PROJECT_NAME, VERSION


def get_application() -> FastAPI:
    application = FastAPI(title=PROJECT_NAME, debug=DEBUG, version=VERSION)

    application.include_router(api_router)

    return application


application = get_application()
