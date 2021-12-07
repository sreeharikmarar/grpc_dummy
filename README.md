# gRPC example

## Pre requisite

#### Protocol buffer installation
```
$: brew install protobuf
$: protoc --version  # Ensure compiler version is 3+
```

## Server

### go

Generate a server interface

```
$: protoc proto/customer_service.proto --go_grpc_out=server/go/protocol --go_grpc_opt=paths=source_relative
```

Start Server

```
$ SERVER_PORT=8080 go run server/go/server.go
```