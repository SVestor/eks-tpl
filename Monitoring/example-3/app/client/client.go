package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
	"strconv"
	"time"
)

// This variable is set during build through -ldflags
var Version = "latest"

var sleepDuration time.Duration

func main() {
	fmt.Println("🚀 App version:", Version)

	// Get sleep duration from environment variable (in ms) to simulate delay between requests
	// Default to 0 if not set
	sleepMsStr := os.Getenv("SLEEP_MS")
	if sleepMsStr == "" {
		sleepMsStr = "0" // default to no delay
	}
	sleepMs, err := strconv.Atoi(sleepMsStr)
	if err != nil {
		log.Fatalf("Invalid SLEEP_MS: %v", err)
	}
	sleepDuration = time.Duration(sleepMs) * time.Millisecond

	mode := os.Getenv("MODE")

	switch mode {
	case "errors":
		log.Println("Running in generateErrors mode")
		generateErrors()
	default:
		log.Println("Running in general mode")
		general()
	}
}

func general() {
	for {
		req("GET", "https://api.svestor.link/devices")
		req("POST", "https://api.svestor.link/devices")
		req("PUT", "https://api.svestor.link/devices/123")

		req("GET", "https://api.svestor.link/devices")
		req("GET", "https://api.svestor.link/devices")
		req("GET", "https://api.svestor.link/devices")
		req("GET", "https://api.svestor.link/devices")
		req("POST", "https://api.svestor.link/devices")
		req("POST", "https://api.svestor.link/devices")
		req("POST", "https://api.svestor.link/devices")
		req("PUT", "https://api.svestor.link/devices/123")
		req("PUT", "https://api.svestor.link/devices/123")
		req("PUT", "https://api.svestor.link/devices/123")
		req("PUT", "https://api.svestor.link/devices/123")
		req("GET", "https://api.svestor.link/devices")
		req("GET", "https://api.svestor.link/devices")
		req("GET", "https://api.svestor.link/devices")
		req("GET", "https://api.svestor.link/devices")
		req("POST", "https://api.svestor.link/devices")
		req("POST", "https://api.svestor.link/devices")
		req("POST", "https://api.svestor.link/devices")
		req("PUT", "https://api.svestor.link/devices/123")
		req("PUT", "https://api.svestor.link/devices/123")
		req("PUT", "https://api.svestor.link/devices/123")
		req("PUT", "https://api.svestor.link/devices/123")

		req("POST", "https://api.svestor.link/login")
		req("DELETE", "https://api.svestor.link/devices/123")
	}
}

func generateErrors() {
	for {
		req("POST", "https://api.svestor.link/login")
		req("DELETE", "https://api.svestor.link/devices/123")
		req("PUT", "https://api.svestor.link/devices/123")
		req("POST", "https://api.svestor.link/login")
		req("DELETE", "https://api.svestor.link/devices/123")
		req("POST", "https://api.svestor.link/login")
		req("DELETE", "https://api.svestor.link/devices/123")
	}
}

func req(method string, url string) {
	client := &http.Client{}

	req, err := http.NewRequest(method, url, nil)
	if err != nil {
		log.Println("Error creating request:", err)
		return
	}
	resp, err := client.Do(req)
	if err != nil {
		log.Println("Error making request:", err)
		return
	}
	defer resp.Body.Close()

	log.Printf("%s %s -> %d\n", method, url, resp.StatusCode)

	time.Sleep(sleepDuration)
}
