FROM golang:1.19.6-buster AS build

WORKDIR /app

COPY go.mod ./
COPY go.sum ./

RUN go mod download && go mod verify

COPY main.go main.go

RUN go build -o /app/main main.go

FROM gcr.io/distroless/base-debian11

COPY --from=build /app/main /app

ENTRYPOINT ["/app"]
