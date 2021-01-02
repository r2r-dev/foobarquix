#FROM python:3.8.1-slim-buster
FROM mirror.gcr.io/library/python@sha256:cede59c0e2fcbabed9b3094f1564917632ecdd11c25c2a275654946938225ef4
ENV PYTHONUNBUFFERED 1

RUN \
echo 'deb     [check-valid-until=no] http://snapshot.debian.org/archive/debian/20201228T203251Z/ buster main contrib non-free' > /etc/apt/sources.list && \
echo 'deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian/20201228T203251Z/ buster main contrib non-free' >> /etc/apt/sources.list && \
echo 'deb     [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20201228T203251Z/ buster/updates main contrib non-free' >> /etc/apt/sources.list && \
echo 'deb-src [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/20201228T203251Z/ buster/updates main contrib non-free' >> /etc/apt/sources.list
RUN \
apt-get update && \
apt-get install -y gcc git curl ccache && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV POETRY_HOME=/opt/poetry
RUN python3 -m pip install --upgrade pip==20.3.1 && \
    curl -sSl https://raw.githubusercontent.com/python-poetry/poetry/a2d2937d7d3336771eab72c60452f59814bbb92d/get-poetry.py -o get-poetry.py && \
    python3 get-poetry.py --version 1.1.4 && \
    chmod 755 -R /opt/poetry/bin/poetry && \
    python3 -m pip install nuitka==0.6.10.4

