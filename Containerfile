FROM registry.redhat.io/rhel9/nodejs-18-minimal AS builder

USER 0
WORKDIR /docs

COPY . .

RUN mkdir -p /opt/app-root/src/.npm-global /docs/node_modules && \
    chown -R 1001:0 /opt/app-root/src /docs && \
    chmod -R g+rw /opt/app-root/src /docs

ENV NPM_CONFIG_PREFIX=/opt/app-root/src/.npm-global
USER 1001

RUN npm install && \
    npx antora antora-playbook.yml --stacktrace --fetch --noproxy '*'

FROM registry.redhat.io/rhel9/nodejs-18-minimal AS runner

USER 0
WORKDIR /opt/app-root/src

RUN mkdir -p /opt/app-root/src/.npm-global && \
    chown -R 1001:0 /opt/app-root/src && \
    chmod -R g+rw /opt/app-root/src

ENV NPM_CONFIG_PREFIX=/opt/app-root/src/.npm-global
ENV PATH=$NPM_CONFIG_PREFIX/bin:$PATH

USER 1001

RUN npm install -g http-server

COPY --from=builder /docs/site ./site

EXPOSE 8080

CMD ["http-server", "site", "-p", "8080"]