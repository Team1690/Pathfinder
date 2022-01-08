package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"os/exec"
	"sync"

	"github.com/Team1690/Pathfinder/rpc"
	"google.golang.org/grpc"
)

var (
	port  = flag.Int("port", 3000, "The server port")
	debug = flag.Bool("debug", false, "Don't run GUI")
)

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

func startGui(logger *log.Logger, wg *sync.WaitGroup) {
	err := exec.Command("pathfinder.exe").Run()
	if err != nil {
		log.Fatalf("Failed to run GUI: %v", err)
	}
	wg.Done()
}

func main() {
	logger := log.Default()

	// Get variables from command line
	flag.Parse()

	wg := sync.WaitGroup{}

	// start algorirthm server without wait group - closes with GUI
	go startAlgorithmServer(port, logger)

	// Run GUI if not in debug
	if !*debug {
		wg.Add(1)
		go startGui(logger, &wg)
	}

	wg.Wait()
}
