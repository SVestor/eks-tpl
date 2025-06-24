FROM golang:1.19.6-buster AS build

WORKDIR /app

ARG VERSION=v1.0.1
ARG APP_NAME=app-client
ARG SRC=client.go

COPY ${SRC} ./
COPY Makefile ./

RUN make init && make tidy && make build VERSION=${VERSION} APP_NAME=${APP_NAME} SRC=${SRC}

FROM gcr.io/distroless/base-debian11

# ENV MODE=errors
# ENV SLEEP_MS=500

COPY --from=build /app/app-client /client

ENTRYPOINT ["/client"]
