# Use the official Golang image as a parent image
FROM golang:1.18-alpine 

ENV GO111MODULE=on

# Use the official golang module proxy
ENV GOPROXY=http://proxy.golang.org
# Set the working directory inside the container
WORKDIR /app

COPY go.mod .
COPY go.sum .

# Get dependencies. Will be cached as long as go.mod and go.sum do not change
RUN go mod download

# Copy the Go application source code into the container
COPY . .

# Build the Go application
RUN GOOS=linux GOARCH=amd64 go build -o /usr/local/grpc-dummy ./server/go/server.go

# Expose the gRPC port
EXPOSE 8080

# Define the command to run the application
CMD ["/usr/local/grpc-dummy"]