FROM golang:1.13 AS builder

WORKDIR /build

COPY src /build

RUN go get -d -v ./... && \
    GOOS=linux go build -o webhook && \
    chmod +x /build/webhook

FROM gcr.io/distroless/base

COPY --from=builder /build/webhook /

CMD ["/webhook"]