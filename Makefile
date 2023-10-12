# Makefile for grpc-dummy

# Go parameters
GOCMD = go
GOBUILD = $(GOCMD) build
GOTEST = $(GOCMD) test
GOCLEAN = $(GOCMD) clean
GOGET = $(GOCMD) get

# Application binary name
BINARY_NAME = grpc-dummy

# Package information
PKG = github.com/sreeharikmarar/grpc_dummy/server/go

# Docker parameters
DOCKER = docker
DOCKER_IMAGE_NAME = grpc-dummy-image
DOCKER_IMAGE_TAG = latest
DOCKER_REPO = sreeharikmarar/grpc-dummy

# Default target
all: build

# Build the application
build:
	$(GOBUILD) -o $(BINARY_NAME) $(PKG)

# Clean build artifacts
clean:
	$(GOCLEAN)
	rm -f $(BINARY_NAME)

# Run tests
test:
	$(GOTEST) -v ./...

# Install dependencies
get:
	$(GOGET)

# Build Docker image
docker-build:
	$(DOCKER) build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .

# Push Docker image to a registry
docker-push:
	$(DOCKER) tag $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) $(DOCKER_REPO):$(DOCKER_IMAGE_TAG)
	$(DOCKER) push $(DOCKER_REPO):$(DOCKER_IMAGE_TAG)

.PHONY: all build clean test get docker-build docker-push
