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
apt-get install -y gcc git && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /build

# TODO: poetry
COPY poetry.lock pyproject.toml wsgi.py /build/
RUN pip3 install poetry==1.1.4 
RUN poetry config virtualenvs.create false --local && poetry install --no-dev && pip3 install nuitka==0.6.8.4
COPY ./app /build/app/
RUN python3 -m nuitka --enable-plugin="implicit-imports" --standalone --follow-imports /build/wsgi.py


# gcr.io/distroless/cc-debian10:nonroot
FROM gcr.io/distroless/cc-debian10@sha256:54c7c58597fef585fd57e66dba643df135a6b24d221ead7318b1e6787f369fe6
USER nonroot
WORKDIR /
COPY --from=0 /build/wsgi.dist /app
CMD ["./app/wsgi"]  

