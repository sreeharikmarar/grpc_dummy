package main

import (
	"log"
	"net"
	"os"
	"strconv"
	"sync"

	"golang.org/x/net/context"

	"github.com/sreeharikmarar/grpc_dummy/pb"

	"google.golang.org/grpc"
	"google.golang.org/grpc/health"
	"google.golang.org/grpc/health/grpc_health_v1"
	"google.golang.org/grpc/reflection"
)

type customerService struct {
	customers []*pb.Person
	m         sync.Mutex
}

func (cs *customerService) ListPerson(p *pb.RequestType, stream pb.CustomerService_ListPersonServer) error {
	cs.m.Lock()
	defer cs.m.Unlock()
	for _, p := range cs.customers {
		if err := stream.Send(p); err != nil {
			return err
		}
	}
	return nil
}

func (cs *customerService) AddPerson(c context.Context, p *pb.Person) (*pb.ResponseType, error) {
	cs.m.Lock()
	defer cs.m.Unlock()
	cs.customers = append(cs.customers, p)
	return new(pb.ResponseType), nil
}

func (cs *customerService) Ping(c context.Context, p *pb.PingRequest) (*pb.PongResponse, error) {
	cs.m.Lock()
	defer cs.m.Unlock()
	return &pb.PongResponse{Pong: "PONG"}, nil
}

func main() {
	port := getServerPort()
	log.Printf("starting server on port: %v", port)
	lis, err := net.Listen("tcp", ":"+strconv.Itoa(port))
	if err != nil {
		log.Fatalf("faild to listen: %v", err)
	}
	server := grpc.NewServer()

	healthServer := health.NewServer()
	grpc_health_v1.RegisterHealthServer(server, healthServer)
	healthServer.SetServingStatus("grpc_dummy service", grpc_health_v1.HealthCheckResponse_SERVING)

	pb.RegisterCustomerServiceServer(server, new(customerService))
	reflection.Register(server)
	server.Serve(lis)
}

func getServerPort() int {
	serverPort := os.Getenv("SERVER_PORT")

	if serverPort != "" {
		port, err := strconv.Atoi(serverPort)
		if err != nil {
			return 8080
		}
		return port
	}
	return 8080
}
