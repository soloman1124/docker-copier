# syntax=docker/dockerfile:1.3

FROM python:3.9.12-slim AS base


FROM base AS builder

RUN pip install --no-cache-dir \
  markupsafe==2.0.1 \
  copier==5.1.0

FROM base AS final

LABEL io.whalebrew.name copier

ENV DEST_PATH=/workdir

WORKDIR ${DEST_PATH}

RUN apt-get update \
    && apt-get install -y \
    git \
    && rm -rf /var/lib/apt/lists/*

# # Copy over python packages and copier script from builder
COPY --from=builder /usr/local/lib/python3.9 /usr/local/lib/python3.9
COPY --from=builder /usr/local/bin/copier /usr/local/bin/copier

ENTRYPOINT [ "copier" ]
