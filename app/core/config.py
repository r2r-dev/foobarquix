from starlette.config import Config

config = Config(".env")
DEBUG: bool = config("DEBUG", cast=bool, default=False)
PROJECT_NAME: str = config("PROJECT_NAME", default="FooBarQix application")
VERSION = "0.1.0"
