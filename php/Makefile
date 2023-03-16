main: Dockerfile
	docker build --pull --rm -f Dockerfile -t dev-env-php:latest .
	docker build --platform=linux/amd64 --pull --rm -f Dockerfile -t dev-env-php:amd64 .
