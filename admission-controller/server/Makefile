.PHONY: test
test:
	@echo "\n🛠️  Running unit tests..."
	go test ./...

.PHONY: build
build:
	@echo "\n🔧  Building Go binaries..."
	GOOS=darwin GOARCH=amd64 go build -o bin/admission-webhook-darwin-amd64 .
	GOOS=linux GOARCH=amd64 go build -o bin/admission-webhook-linux-amd64 .

.PHONY: docker-build
docker-build:
	docker build -t simple-kubernetes-webhook:latest .

.PHONY: push
push: docker-build
	minikube image load simple-kubernetes-webhook

.PHONY: deploy
deploy:
	kubectl apply -f ../resources

.PHONY: delete
delete:
	kubectl delete -f ../resources
