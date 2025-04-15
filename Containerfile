FROM registry.redhat.io/rhel9/nodejs-18-minimal

COPY . /tmp
WORKDIR /tmp

USER 0
RUN ./build-docs.sh

USER 1001
EXPOSE 8080

CMD ["npx", "http-server", "site", "-p", "8080"]
