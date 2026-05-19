#!/bin/bash

set -o pipefail

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
        $DOCKER_COMPOSE up -d --build --remove-orphans | {
            echo "❌ Docker Compose start failed."
            exit 1
        }

        echo "✅ Containers are running."
        echo ""
        echo "🌐 Access:"
        echo " - KitchenNotes: http://$HOSTNAME:5001/"
        echo " - Crypto Tracker: http://$HOSTNAME:8000/"
        echo " - Trade Vista:    http://$HOSTNAME:8080/"
        ;;
    
    stop)
        echo "🛑 Stopping infrastructure..."
        $DOCKER_COMPOSE down 
        echo "✅ Containers stopped."
        ;;

    clear)
        echo "🧹 Stopping infrastructure and removing all images..."
        $DOCKER_COMPOSE down -v --rmi all 
        echo "✅ Clear complete."
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
        $DOCKER_COMPOSE logs -f || true
        ;;

    prune)
        echo "🧹 Pruning unused resources..."
        docker system prune -a -f
        echo "✅ Pruning complete."
        ;;
    
    *)
        echo "Usage: $0 {start|stop|clear|restart|status|logs|prune}"
        exit 1
        ;;
esac
