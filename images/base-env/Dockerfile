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
apt-get install -y gcc git curl ccache && \
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV POETRY_HOME=/opt/poetry
RUN curl -sSl https://raw.githubusercontent.com/python-poetry/poetry/a2d2937d7d3336771eab72c60452f59814bbb92d/get-poetry.py -o get-poetry.py && \
    python3 get-poetry.py --version 1.1.4 && \
    chmod 755 -R /opt/poetry/bin/poetry && \
    python3 -m pip install nuitka==0.6.10.4

