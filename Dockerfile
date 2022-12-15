FROM python:3.9-slim-bullseye as builder

RUN apt-get update && \
  apt-get install -y make libsasl2-dev unixodbc-dev python3-venv antlr4

WORKDIR /srv
COPY . ./
RUN make install_dev generate install && \
  cd ingestion && \
  python setup.py install sdist bdist_wheel

FROM scratch as artifact
COPY --from=builder /srv/ingestion/dist/* .
