FROM python:2-alpine

RUN apk add  --no-cache --update gcc musl-dev
RUN pip install  --no-cache-dir vnc2flv

COPY entrypoint.sh /tmp/
COPY wait-for /tmp/
WORKDIR /tmp/
ENTRYPOINT ["/tmp/entrypoint.sh"]
