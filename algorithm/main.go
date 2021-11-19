package main

import (
	"flag"
	"fmt"
	"log"
	"net"

	"github.com/Team1690/Pathfinder/rpc"
	"google.golang.org/grpc"
)

var (
	port = flag.Int("port", 50051, "The server port")
)

func main() {
	// Get variables from command line
	flag.Parse()

	// Start network listener on the relevant port
	lis, err := net.Listen("tcp", fmt.Sprintf("localhost:%d", *port))
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}

	// Init the gRPC server on the net listener
	grpcServer := grpc.NewServer()
	rpc.RegisterPathFinderServer(grpcServer, rpc.NewServer())
	grpcServer.Serve(lis)
}
