# web-infra-deploy

Deployment Infrastructure for web applications.

This project orchestrates the deployment of three services:

- `Kitchen-Notes` (Python application)
- `Trade-Vista` (Go application) 
- `Crypto-Tracker` (Python application)

Both services are exposed through a reverse proxy using Nginx.

## Project Structure

````
web-infra-deploy/
| - nginx/
    | - nginx.conf
| - docker-compose.yml
| - README.md
````

## Building Infrastructure for Web Applications

This section describes how the infrastructure is composed and how the different components interact.

### Architecture Overview

The system consists of three main components:

. Application services: `Kitchen-Notes`, `Trade-Vista` and `Crypto-Tracker`
. Reverse Proxy: Nginx acts as a single entry point and routes incoming HTTP requests to the approriate service.
. Persistent Storage: Host-mounted volumes are used to persist application data outside the containers.

#### Docker Compose Configuration 

The `docker-compose.yml` file defines and manages all services.

#### Nginx

Nginx is responsible for routing requests to the correct backend service based on the URL path.

### Running the infrasctructure

**Prerequisites**

Before starting the infrastructure, make sure the Docker images for both services are built:

- kitchen-notes
- trade-vista
- crypto-tracker

#### Manual Starting

You can build them using:

````bash
# run inside each project directory
docker build -t kitchen-notes .

docker build -t trade-vista .

docker build -t crypto-tracker .
````

**Start all services**

````bash
cd web-infra-deploy

# start all services in detached mode
sudo docker compose up -d --build --remove-orphans
````

**Restart, Rebuild services**

````bash
# restart nginx service
docker compose restart nginx

# rebuild nginx service
docker compose up -d --build nginx
````

**Stop the service**

To stop the service:

````bash
# remove all images and containers
docker compose down -v --rmi all
````

#### Using Infrastructure Management Script

The `infra.sh` script provides a simple interface to manage the entire Docker-based infrastructure. It wraps common Docker Compose commands and simplifies working with the project.

**Features:**

* Start all services (including automatic image build)
* Stop and remove containers
* Restart the infrastructure
* View container status
* Stream logs from all services
* Automatically loads environment variables from .env

**Usage**

````bash
./infra.sh start     # Build and start all services
./infra.sh stop      # Stop and remove containers
./infra.sh restart   # Restart all services
./infra.sh status    # Show running containers
./infra.sh logs      # Show logs (live)
````

### Accessing the applications

Once the infrastructure is running, access the applications via your web browser:

- Kitchen Notes app: http://<your_host>:5001
- Trade-Vista app: http://<your_host>:8080
- Crypto-Tracker app: hhtp://<your_host>:8000
