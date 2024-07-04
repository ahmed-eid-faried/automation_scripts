# Usage Instructions for Laravel with Docker Setup

## Step-by-Step Instructions

1.  **Ensure Docker is installed and running:** Check if Docker is installed on your system and running. You can verify this by running the following command in your terminal:  
    `docker --version`
2.  **Download the shell script:** Download the `create_laravel_with_docker.sh` shell script from the repository or create it manually.
3.  **Make the shell script executable:** Navigate to the directory where the script is located and make it executable with the following command:  
    `chmod +x create_laravel_with_docker.sh`
4.  **Run the shell script:** Execute the shell script to set up Laravel with Docker. This will create a new Laravel project and start it with Docker:  
    `./create_laravel_with_docker.sh`
5.  **Check for port conflicts:** After running the script, it will automatically check if essential ports (e.g., 80, 443, 3306, 6379) are in use. Resolve any conflicts if detected.
6.  **Troubleshooting:** If there are issues with Docker or port conflicts, refer to the troubleshooting steps provided in the script and this document.

## Example Shell Script (create_laravel_with_docker.sh)

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
        declare -a PORTS=("80" "443" "3306" "6379")  # Add more ports as needed

        for port in "${PORTS[@]}"; do
            if lsof -Pi :$port -sTCP:LISTEN -t >/dev/null ; then
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

Feel free to modify the script and instructions as per your project's specific requirements.
