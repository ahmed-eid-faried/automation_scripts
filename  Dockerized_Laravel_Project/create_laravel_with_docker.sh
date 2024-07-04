#!/bin/bash

# Check if Docker is running
docker --version >/dev/null 2>&1
DOCKER_INSTALLED=$?

if [ $DOCKER_INSTALLED -ne 0 ]; then
    echo "Error: Docker is not installed or not running."
    echo "Please install Docker and ensure it is running."
    exit 1
fi

# Check if docker-compose.yml exists
if [ ! -f docker-compose.yml ]; then
    echo "Error: docker-compose.yml not found."
    echo "Make sure Sail is properly installed in your Laravel project."
    exit 1
fi

# Recreate Laravel project if it exists
if [ -d example-app ]; then
    echo "Deleting existing example-app directory..."
    rm -rf example-app
fi

echo "Creating new Laravel project with Sail..."
curl -s "https://laravel.build/example-app" | bash
cd example-app

# Start Sail
echo "Starting Sail..."
./vendor/bin/sail up -d

# Check if any problems in port
echo "Checking if ports are in use..."
declare -a PORTS=("80" "443" "3306" "6379") # Add more ports as needed

for port in "${PORTS[@]}"; do
    if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null; then
        echo "Port $port is in use."
    else
        echo "Port $port is free."
    fi
done

# Additional troubleshooting steps
echo "Additional troubleshooting steps:"
echo "- If Sail doesn't start, try running './vendor/bin/sail up' directly."
echo "- Ensure there are no conflicting applications using Docker or ports."
echo "- Check permissions and use 'sudo' if necessary."

echo "Laravel with Docker setup completed successfully."
