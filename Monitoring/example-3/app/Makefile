# Name of the binary to be built
APP_NAME := app-server
SRC := server.go
VERSION := v1.0.0

# Go version for checking (optional)
REQUIRED_GO_VERSION := 1.19

# Commands
.PHONY: all init tidy build run clean version

all: build

init:
	go mod init $(APP_NAME) || true

tidy:
	go mod tidy

build:
	@echo "🔨 Building $(APP_NAME) with version=$(VERSION)..."
	go build -ldflags "-X main.Version=$(VERSION)" -o $(APP_NAME) $(SRC)

run: build
	@echo "🚀 Running $(APP_NAME) with version=$(VERSION)..."
	GIN_MODE=release ./$(APP_NAME)

test-run:
	@echo "🧪 Running $(SRC)..."
	go run $(SRC)

clean:
	@echo "🧹 Cleaning..."
	rm -f $(APP_NAME)

version:
	@echo "🔎 Checking Go version..."
	@go version | grep "go$(REQUIRED_GO_VERSION)" || (echo "⚠️ Go $(REQUIRED_GO_VERSION) required!" && exit 1)
