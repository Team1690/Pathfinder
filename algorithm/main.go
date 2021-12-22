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
	port = flag.Int("port", 3000, "The server port")
)

func main() {
	logger := log.Default()

	// Get variables from command line
	flag.Parse()

	// Start network listener on the relevant port
	lis, err := net.Listen("tcp", fmt.Sprintf("localhost:%d", *port))
	if err != nil {
		log.Fatalf("Failed to listen: %v", err)
	}

	// Init the gRPC server on the net listener
	grpcServer := grpc.NewServer()
	rpc.RegisterPathFinderServer(grpcServer, NewServer(logger))

	logger.Printf("Starting server on port %d", *port)

	if err := grpcServer.Serve(lis); err != nil {
		log.Fatalf("Failed to serve: %v", err)
	}
}
