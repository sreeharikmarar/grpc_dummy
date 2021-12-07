# gRPC example

## Pre-requisite

#### Protocol buffer installation
```
$: brew install protobuf
$: protoc --version  # Ensure compiler version is 3+
```

## Server

### go

Generate a server interface

```
$: protoc --go_out=. --go-grpc_opt=require_unimplemented_servers=false --go-grpc_out=. proto/customer_service.proto
```

Start Server

```
$ SERVER_PORT=8080 go run server/go/server.go
```

## Client

### grpcui

```
$: grpcui --plaintext localhost:8080
gRPC Web UI available at http://127.0.0.1:51685/
```
