# Use the official Golang image as a parent image
FROM golang:1.17

# Set the working directory inside the container
WORKDIR /app

# Copy the Go application source code into the container
COPY . .

# Build the Go application
RUN go build -o grpc-dummy ./server/go

# Expose the gRPC port
EXPOSE 50051

# Define the command to run the application
CMD ["./grpc-dummy"]