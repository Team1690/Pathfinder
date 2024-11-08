package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"sync"

	"github.com/Team1690/Pathfinder/rpc"
	"google.golang.org/grpc"
)

var (
	port = flag.Int("port", 3000, "The server port")
)

func main() {
	// Parse command line flags
	flag.Parse()
	logger := log.Default()

	// Start a wait group this is to allow the server to run continuously until closed manually
	wg := sync.WaitGroup{}
	wg.Add(1)

	// Start Server
	go startAlgorithmServer(port, logger)

	// Block program from exiting
	wg.Wait()
}

func startAlgorithmServer(port *int, logger *log.Logger) {
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
