FROM registry.access.redhat.com/ubi9/nodejs-20

COPY . /opt/app-root/src
WORKDIR /opt/app-root/src

USER 0
RUN ./build-docs.sh

USER 1001
EXPOSE 8080

CMD ["npx", "http-server", "site", "-p", "8080"]
