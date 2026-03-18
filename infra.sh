#!/bin/bash

set -e

# --- Load environment variables ---
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "❌ .env file not found. Please create one."
    exit 1
fi

# --- Helper: check docker compose ---
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed."
    exit 1
fi

# Use modern docker compose if available
DOCKER_COMPOSE="docker compose"

# --- Commands ---
case "$1" in
    start)
        echo "🚀 Starting infrastructure..."
        $DOCKER_COMPOSE up -d --build

        echo "✅ Containers are running."
        echo ""
        echo "🌐 Access:"
        echo " - Crypto Tracker: http://localhost/cryptotracker/"
        echo " - Trade Vista:    http://localhost/trade-vista/"
        ;;
    
    stop)
        echo "🛑 Stopping infrastructure..."
        $DOCKER_COMPOSE down
        echo "✅ Containers stopped."
        ;;
    
    restart)
        echo "🔄 Restarting infrastructure..."
        $DOCKER_COMPOSE down
        $DOCKER_COMPOSE up -d --build
        echo "✅ Restart complete."
        ;;
    
    status)
        echo "📊 Container status:"
        $DOCKER_COMPOSE ps
        ;;
    
    logs)
        echo "📜 Showing logs..."
        $DOCKER_COMPOSE logs -f
        ;;
    
    *)
        echo "Usage: $0 {start|stop|restart|status|logs}"
        exit 1
        ;;
esac
