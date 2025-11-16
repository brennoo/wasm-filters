# Go parameters
GOCMD=go
GOCLEAN=$(GOCMD) clean
GOTEST=$(GOCMD) test
GOGET=$(GOCMD) get
BINARY_NAME=http-trace-filter.wasm

all: build

build: build_filter

build_filter:
	mkdir -p bin
	env GOOS=wasip1 GOARCH=wasm $(GOCMD) build -buildmode=c-shared -o ./bin/$(BINARY_NAME) src/trace/main.go

.PHONY: docker_build
docker_build:
	@echo "Running make docker_build"
	@DOCKER_BUILDKIT=1 docker build --file docker/Dockerfile.build.local --target bin --output bin/ .

docker_release:
	@echo "Running make docker_release"
	@DOCKER_BUILDKIT=1 docker build --file docker/Dockerfile.build.local --target bin --output bin/release .

clean:
	$(GOCLEAN)
	rm -f ./bin/*.wasm
