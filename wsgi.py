"""
Runs the project in gunicorn
"""
from gunicorn.app.base import Application
import app.asgi

import sys
import os

def run_uwsgi():
    class MyApplication(Application):
        """
        Bypasses the class `WSGIApplication` and made it 
        independent from command line arguments
        """
        def init(self, parser, opts, args):

            self.cfg.set("default_proc_name", args[0])

            # Added this to ensure the application integrity
            self.app_uri = "app.asgi:application"

        def load_wsgiapp(self):
            # This would do the trick
            # returns application callable
            return app.asgi.get_application()

        def load(self):
            return self.load_wsgiapp()

    sys.argv = ["--gunicorn", "-w", "2", "-k", "uvicorn.workers.UvicornWorker"]

    sys.argv.append(f"-b {os.environ['APP_HOST']}:{os.environ['APP_PORT']}")

    # Throws an error if this is missing.
    sys.argv.append("app.asgi:application")

    MyApplication(usage="%(prog)s [OPTIONS] [APP_MODULE]").run()

if __name__ == '__main__':
  run_uwsgi()
