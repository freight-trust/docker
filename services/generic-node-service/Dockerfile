ARG TAG=latest
FROM monorepo/cool-node:${TAG}


WORKDIR ${ROOT_DIR}/services/generic-node-service

COPY ./package.json ./
RUN npm install

COPY . .
CMD npm start


ARG BUILD_DATE
ARG VCS_REF
ARG VERSION
LABEL org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="Base Container " \
      org.label-schema.description="Generic Docker" \
      org.label-schema.url="https://docker.freighttrust.com/" \
      org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/freight-trust/action-docker.git" \
      org.label-schema.vendor="Freight Trust & Clearing" \
      org.label-schema.version=$VERSION \
      org.label-schema.schema-version="1.0"