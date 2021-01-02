"""Runs the project in gunicorn."""
import os
import sys

from gunicorn.app.base import Application

from app.asgi import get_application


def run_uwsgi(host, port, workers):
    class ApplicationLoader(Application):
        """Bypasses the class `WSGIApplication`."""

        def init(self, parser, opts, args):

            self.cfg.set("default_proc_name", args[0])

            # Added this to ensure the application integrity
            self.app_uri = "app.asgi:application"

        def load_wsgiapp(self):
            # This would do the trick
            # returns application callable
            return get_application()

        def load(self):
            return self.load_wsgiapp()

    sys.argv = [
        "--gunicorn",
        "-w",
        workers,
        "-k",
        "uvicorn.workers.UvicornWorker",
        "-b {host}:{port}".format(
            host=host,
            port=port,
        ),
    ]

    # Throws an error if this is missing.
    sys.argv.append("app.asgi:application")

    ApplicationLoader().run()


if __name__ == "__main__":
    run_uwsgi(
        host=os.getenv("APP_HOST", "localhost"),
        port=os.getenv("APP_PORT", "8000"),
        workers=os.getenv("WORKERS", "4"),
    )
