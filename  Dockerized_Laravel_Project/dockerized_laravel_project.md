# Dockerized Laravel Project README

## Usage

To manage your Dockerized Laravel project, follow these steps:

### Step 1: Execute the deploy.sh script

    ./deploy.sh <command>

Replace `<command>` with one of the following:

- `up`: Starts Docker containers.
- `down`: Stops Docker containers.
- `migrate`: Runs Laravel database migrations.
- `fresh`: Resets the database and runs migrations.
- `migrate-seed`: Resets the database, runs migrations, and seeds the database.
- `restart`: Stops and then starts Docker containers.

### Example Usage

To start Docker containers:

    ./deploy.sh up

To run migrations:

    ./deploy.sh migrate

## Notes

- Ensure Docker is installed and running on your system.
- Adjust ports and configurations in `docker-compose.yml` and `Dockerfile` according to your project's requirements.
- Customize `supervisord.conf` inside your Laravel project for managing queues and other processes as needed.

For more information, refer to the [Docker documentation](https://docs.docker.com/) and [Laravel documentation](https://laravel.com/docs).
