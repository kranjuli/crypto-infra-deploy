# crypto-infra-deploy

Deployment Infrastructure for crypto-related applications.

This project orchestrates the deployment of two services:

- `Trade-Vista` (Go application) 
- `Crypto-Tracker` (Python application)

Both services are exposed through a reverse proxy using Nginx.

## Project Structure

````
crypto-infra-deploy/
| - nginx/
    | - nginx.conf
| - docker-compose.yml
| - README.md
````

## Building Infrastructure for Crypto Applications

This section describes how the infrastructure is composed and how the different components interact.

### Architecture Overview

The system consists of three main components:

. Application services: `Trade-Vista` and `Crypto-Tracker`
. Reverse Proxy: Nginx acts as a single entry point and routes incoming HTTP requests to the approriate service.
. Persistent Storage: Host-mounted volumes are used to persist application data outside the containers.

#### Docker Compose Configuration 

The `docker-compose.yml` file defines and manages all services:

````
services:
  crypto-tracker:
    image: crypto-tracker:latest
    volumes:
      - /mnt/ssd/data/crypto_tracker/data:/app/data
    container_name: crypto-tracker
    ports:
      - "8000:8000"

  trade-vista:
    image: trade-vista:latest
    container_name: trade-vista
    volumes:
      - /mnt/ssd/data/bvv_transactions:/app/transactions:ro
    ports:
      - "8080:8080"

  nginx:
    image: nginx:latest
    container_name: nginx
    ports:
      - "80:80"
    volumes:
      - ./nginx/nginx.conf:/etc/nginx/nginx.conf:ro
    depends_on:
      - crypto-tracker
      - trade-vista

````

#### Nginx

Nginx is responsible for routing requests to the correct backend service based on the URL path.

````
http {
    server {
        listen 80;

        location /trade-vista/ {
            proxy_pass http://trade-vista:8080/;
        }

        location /cryptotracker/ {
            proxy_pass http://crypto-tracker:8000/;
        }
    }
}
````

Notes:

- Requests to /trade-vista/ are forwarded to the Go application.
- Requests to /cryptotracker/ are forwarded to the Python application.
- Docker’s internal DNS allows service names (`trade-vista`, `crypto-tracker`) to be resolved automatically.

### Running the infrasctructure

**Prerequisites**

Before starting the infrastructure, make sure the Docker images for both services are built:

- trade-vista
- crypto-tracker

#### Manual Starting

You can build them using:

````bash
# run inside each project directory
docker build -t trade-vista .

docker build -t crypto-tracker .
````

**Start the services**

````bash
cd infra deploy

# start all services in detached mode
sudo docker compose up -d
````

To stop the services:

````bash
sudo docker compose down 
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

- Trade-Vista app: http://<your_host>/trade-vista
- Crypto-Tracker app: hhtp://<your_host>/crypto-tracker
