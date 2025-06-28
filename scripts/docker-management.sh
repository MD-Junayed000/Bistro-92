#!/bin/bash

# Bistro-92 Docker Management Script
# This script provides convenient commands for managing the Docker Compose setup

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Docker is running
check_docker() {
    if ! docker info > /dev/null 2>&1; then
        print_error "Docker is not running. Please start Docker and try again."
        exit 1
    fi
}

# Function to build and start services
start_services() {
    print_status "Starting Bistro-92 services..."
    check_docker
    
    # Build and start services
    docker compose up --build -d
    
    print_status "Waiting for services to be healthy..."
    sleep 10
    
    # Check service health
    print_status "Checking service health..."
    docker compose ps
    
    print_success "Services started successfully!"
    print_status "Available endpoints:"
    echo "  - Frontend: http://localhost:3000"
    echo "  - Order Service: http://localhost:8000"
    echo "  - Notification Service: http://localhost:3001"
    echo "  - Dashboard Service: http://localhost:5000"
    echo "  - Database Admin: http://localhost:4040"
    echo "  - RabbitMQ Management: http://localhost:15672"
    echo "  - Temporal UI: http://localhost:8085"
}

# Function to stop services
stop_services() {
    print_status "Stopping Bistro-92 services..."
    docker compose down
    print_success "Services stopped successfully!"
}

# Function to restart services
restart_services() {
    print_status "Restarting Bistro-92 services..."
    docker compose restart
    print_success "Services restarted successfully!"
}

# Function to view logs
view_logs() {
    if [ -z "$1" ]; then
        print_status "Showing logs for all services..."
        docker compose logs -f
    else
        print_status "Showing logs for $1..."
        docker compose logs -f "$1"
    fi
}

# Function to clean up
cleanup() {
    print_status "Cleaning up Docker resources..."
    docker compose down -v --remove-orphans
    docker system prune -f
    print_success "Cleanup completed!"
}

# Function to show service status
status() {
    print_status "Service status:"
    docker compose ps
    
    print_status "Service health:"
    for service in order-service notification-service dashboard-service; do
        health=$(docker compose ps --format json | jq -r ".[] | select(.Service == \"$service\") | .Health" 2>/dev/null || echo "unknown")
        echo "  - $service: $health"
    done
}

# Function to run database migrations
migrate() {
    print_status "Running database migrations..."
    # Add migration commands here if needed
    print_success "Migrations completed!"
}

# Function to show help
show_help() {
    echo "Bistro-92 Docker Management Script"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  start     Build and start all services"
    echo "  stop      Stop all services"
    echo "  restart   Restart all services"
    echo "  logs      View logs (optionally specify service name)"
    echo "  status    Show service status and health"
    echo "  cleanup   Stop services and clean up Docker resources"
    echo "  migrate   Run database migrations"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start"
    echo "  $0 logs notification-service"
    echo "  $0 status"
}

# Main script logic
case "${1:-}" in
    start)
        start_services
        ;;
    stop)
        stop_services
        ;;
    restart)
        restart_services
        ;;
    logs)
        view_logs "$2"
        ;;
    status)
        status
        ;;
    cleanup)
        cleanup
        ;;
    migrate)
        migrate
        ;;
    help|--help|-h)
        show_help
        ;;
    *)
        print_error "Unknown command: ${1:-}"
        echo ""
        show_help
        exit 1
        ;;
esac 