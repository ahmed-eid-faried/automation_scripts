#!/bin/bash

# Function to display script usage
usage() {
    echo "Usage: $0 {up|down|migrate|fresh|migrate-seed|restart}"
    exit 1
}

# Check if a command-line argument is provided
if [ $# -eq 0 ]; then
    usage
fi

# Determine the command to execute based on user input
case "$1" in
up)
    docker-compose up -d
    ;;
down)
    docker-compose down
    ;;
migrate)
    docker-compose exec app php artisan migrate
    ;;
fresh)
    docker-compose exec app php artisan migrate:fresh
    ;;
migrate-seed)
    docker-compose exec app php artisan migrate:fresh --seed
    ;;
restart)
    docker-compose down
    docker-compose up -d
    ;;
*)
    usage
    ;;
esac

exit 0
