FROM java:openjdk-9-jre
MAINTAINER Pat Brisbin <pbrisbin@gmail.com>
ENV LANG en_US.UTF-8
ENV GOOGLE_JAVA_FORMAT_JAR \
  https://github.com/google/google-java-format/releases/download/google-java-format-1.6/google-java-format-1.6-all-deps.jar
RUN curl \
  --location \
  --output /google-java-format.jar "$GOOGLE_JAVA_FORMAT_JAR"
RUN printf "%s\n" "#!/bin/sh" "exec java -jar /google-java-format.jar \"\$@\"" \
  > /usr/bin/google-java-format && \
  chmod +x /usr/bin/google-java-format
RUN mkdir -p /code
WORKDIR /code
CMD ["google-java-format", "--help"]

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Freight Trust Containers" \
      org.label-schema.description="Secure Build" \
      org.label-schema.url="https://docker.freighttrust.com/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/freight-trust/action-docker.git" \
      org.label-schema.vendor="Freight Trust & Clearing" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"
