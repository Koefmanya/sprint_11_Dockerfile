FROM golang:1.22-alpine AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o /out/parcel-tracker .

FROM alpine:3.20

WORKDIR /app

RUN addgroup -S app && adduser -S -G app app && chown app:app /app

COPY --chown=app:app --from=builder /out/parcel-tracker /app/parcel-tracker
COPY --chown=app:app tracker.db /app/tracker.db

USER app

ENTRYPOINT ["/app/parcel-tracker"]
