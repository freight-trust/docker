FROM node:12

ARG TAG=latest
ARG GIT_SHA1=latest


ENV MONOREPO_SHA1 ${GIT_SHA1}
ENV MONOREPO_VERSION ${TAG}

ENV ROOT_DIR /app

WORKDIR ${ROOT_DIR}/bases/node
COPY . .

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Base Container" \
      org.label-schema.description="Docker Schema Generic" \
      org.label-schema.url="https://docker.freighttrust.com/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/freight-trust/action-docker.git" \
      org.label-schema.vendor="Freight Trust & Clearing" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"