ARG TAG=latest
FROM monorepo/fancy-rust:${TAG}

LABEL maintainer="ops@freighttrust.com"

WORKDIR ${ROOT_DIR}/services/generic-rust-service

COPY . .
RUN cargo build --release

CMD target/release/generic-rust-service


ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Base Container " \
      org.label-schema.description="Ubuntu 20.04 Base Container" \
      org.label-schema.url="https://docker.freighttrust.com/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/freight-trust/action-docker.git" \
      org.label-schema.vendor="Freight Trust & Clearing" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"