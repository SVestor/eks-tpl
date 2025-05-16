#!/bin/bash

# First forward port 8080 (or any other port) to the flask-app service
# kubectl port-forward svc/flask-app 8080:8080 -n flask-ns &

# Number of parallel requests
PARALLEL_REQUESTS=50

# Target URL
URL="http://localhost:8080"

# Function to send a single curl request
send_request() {
    while true; do
        curl -s $URL > /dev/null
    done
}

# Run the requests in parallel
for i in $(seq 1 $PARALLEL_REQUESTS); do
    send_request &
done

# Wait for all background jobs to finish
wait
