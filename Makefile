PROJECT_ROOT := $(shell pwd)
NETWORK_NAME := study-net
DB_CONTAINER_NAME := database
DB_USERNAME := $(shell grep '^DB_USERNAME=' .env | cut -d '=' -f 2)
DB_PASSWORD := $(shell grep '^DB_PASSWORD=' .env | cut -d '=' -f 2)
DB_DATABASE := $(shell grep '^DB_DATABASE=' .env | cut -d '=' -f 2)

install:
	docker network ls | grep -q $(NETWORK_NAME) || docker network create $(NETWORK_NAME)
	docker-compose build
	make up
	#docker run --rm -v $(PROJECT_ROOT):/app composer install --ignore-platform-req=ext-exif --ignore-platform-req=ext-intl

	# Retry mechanism for creating the MySQL database
	set -e; for i in {1..50}; do \
	    docker exec "$(DB_CONTAINER_NAME)" bash -c 'mysql -u$(DB_USERNAME) -p$(DB_PASSWORD) --protocol=tcp -h "$(shell docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' $(DB_CONTAINER_NAME))" -e "CREATE DATABASE IF NOT EXISTS  $(DB_DATABASE);"' && break || sleep 2; \
	done;
up:
	docker-compose up -d

down:
	docker-compose down

php:
	docker-compose exec app bash

share:
	ngrok http 443

