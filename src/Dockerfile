FROM python:3.8.1-slim-buster
#FROM python@sha256:56d9bdc243bc53d4bb055305b58cc0be15b05cc09dcda9b9d5e224233889b61b
ENV PYTHONUNBUFFERED 1

RUN \
echo 'deb     [check-valid-until=no] http://snapshot.debian.org/archive/debian/20201228T203251Z/ buster main contrib non-free' > /etc/apt/sources.list && \
echo 'deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20201228T203251Z/ buster main contrib non-free' >> /etc/apt/sources.list && \
echo 'deb     [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20201228T203251Z/ buster/updates main contrib non-free' >> /etc/apt/sources.list && \
echo 'deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20201228T203251Z/ buster/updates main contrib non-free' >> /etc/apt/sources.list
RUN \
apt-get update && \
apt-get install -y gcc git curl && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /build

# TODO: poetry
RUN curl -sSl https://raw.githubusercontent.com/python-poetry/poetry/a2d2937d7d3336771eab72c60452f59814bbb92d/get-poetry.py -o get-poetry.py && \
    python3 get-poetry.py --version 1.1.4 && \
    python3 -m pip install nuitka==0.6.10.4

COPY poetry.lock pyproject.toml wsgi.py /build/
RUN . $HOME/.poetry/env && \
    poetry config virtualenvs.create false --local && \
    poetry install --no-dev 

COPY ./app /build/app/
RUN python3 -m nuitka \
   --include-package=gunicorn \
   --include-package=uvicorn  \
   --include-package=uvloop \
   --include-package=httptools \
   --include-package=click \
   --include-plugin-directory=/build/app \
   --prefer-source-code \
   --plugin-enable=pylint-warnings \
   --enable-plugin="implicit-imports" \
   --standalone \
   --follow-imports \
   --recurse-all \
   --show-modules \
   --output-dir=/app \
    /build/wsgi.py


# gcr.io/distroless/cc-debian10:nonroot
FROM gcr.io/distroless/cc-debian10@sha256:54c7c58597fef585fd57e66dba643df135a6b24d221ead7318b1e6787f369fe6
USER nonroot
WORKDIR /
COPY --from=0 /app/wsgi.dist /app
CMD ["./app/wsgi"]  

