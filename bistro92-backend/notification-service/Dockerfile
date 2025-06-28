# Use the required Go version to match go.mod requirements
FROM golang:1.23-alpine AS builder

# Install minimal required packages
RUN apk add --no-cache ca-certificates git tzdata

WORKDIR /app

# Copy and download dependencies first (better caching)
COPY go.mod go.sum ./
RUN go mod download

# Copy source and build
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -ldflags='-w -s' -o notification-service .

# Use Alpine for health checks instead of distroless
FROM alpine:latest

# Install wget for health checks and ca-certificates
RUN apk --no-cache add wget ca-certificates

# Create non-root user
RUN addgroup -g 1001 nonroot && adduser -D -u 1001 -G nonroot nonroot

# Copy from builder
COPY --from=builder /app/notification-service /notification-service

# Use non-root user
USER nonroot:nonroot

EXPOSE 3001
ENTRYPOINT ["/notification-service"]