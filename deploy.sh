#!/bin/bash

# RisolviAmoSubito.it Deployment Script
# Automated deployment for production environment

set -e  # Exit on any error

echo "🚀 Starting RisolviAmoSubito.it deployment..."
echo "================================================"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if Docker is installed and running
check_docker() {
    if ! command -v docker &> /dev/null; then
        log_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    
    if ! docker info &> /dev/null; then
        log_error "Docker is not running. Please start Docker service."
        exit 1
    fi
    
    if ! command -v docker-compose &> /dev/null; then
        log_error "Docker Compose is not installed. Please install Docker Compose first."
        exit 1
    fi
    
    log_success "Docker and Docker Compose are available"
}

# Create environment file if it doesn't exist
setup_environment() {
    log_info "Setting up environment configuration..."
    
    if [ ! -f .env ]; then
        log_warning ".env file not found, creating from template..."
        cp .env.example .env
        
        echo ""
        echo "⚠️  IMPORTANT: Please edit .env file with your production settings:"
        echo "   - Database passwords"
        echo "   - App secret key"
        echo "   - Email configuration"
        echo "   - Domain name"
        echo ""
        read -p "Press Enter when you've configured .env file..."
    else
        log_success "Environment file found"
    fi
}

# Create required directories
setup_directories() {
    log_info "Creating required directories..."
    
    directories=("logs" "uploads" "cache" "sessions")
    
    for dir in "${directories[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            log_success "Created directory: $dir"
        fi
    done
    
    # Set proper permissions
    chmod 755 logs uploads cache sessions
    log_success "Directories created and permissions set"
}

# Build and start Docker containers
deploy_containers() {
    log_info "Building Docker containers..."
    
    # Stop existing containers
    docker-compose down --remove-orphans
    
    # Build containers (force rebuild)
    docker-compose build --no-cache
    
    # Start services in detached mode
    log_info "Starting services..."
    docker-compose up -d
    
    log_success "Docker containers started"
}

# Wait for services to be ready
wait_for_services() {
    log_info "Waiting for services to be ready..."
    
    # Wait for MySQL
    echo "Waiting for MySQL..."
    until docker-compose exec -T database mysqladmin ping -h localhost --silent; do
        echo -n "."
        sleep 2
    done
    echo ""
    log_success "MySQL is ready"
    
    # Wait for Redis
    echo "Waiting for Redis..."
    until docker-compose exec -T redis redis-cli ping | grep -q PONG; do
        echo -n "."
        sleep 1
    done
    echo ""
    log_success "Redis is ready"
    
    # Wait for web server
    echo "Waiting for web server..."
    sleep 5
    log_success "Web server should be ready"
}

# Setup SSL certificates
setup_ssl() {
    log_info "Setting up SSL certificates..."
    
    # Check if running in production
    if grep -q "APP_ENV=production" .env; then
        log_info "Production environment detected, setting up Let's Encrypt..."
        
        # Extract domain from .env
        DOMAIN=$(grep APP_URL .env | cut -d '=' -f2 | sed 's/https\?:\/\///')
        
        if [ ! -z "$DOMAIN" ] && [ "$DOMAIN" != "localhost" ]; then
            log_info "Setting up SSL for domain: $DOMAIN"
            
            # Install certbot in web container
            docker-compose exec web apt-get update
            docker-compose exec web apt-get install -y certbot python3-certbot-apache
            
            # Get SSL certificate
            docker-compose exec web certbot --apache \
                -d "$DOMAIN" \
                --email "admin@$DOMAIN" \
                --agree-tos \
                --non-interactive
            
            log_success "SSL certificate installed for $DOMAIN"
        else
            log_warning "No valid domain found in APP_URL, skipping SSL setup"
        fi
    else
        log_info "Development environment, skipping SSL setup"
    fi
}

# Set proper file permissions
set_permissions() {
    log_info "Setting file permissions..."
    
    # Set ownership to www-data inside container
    docker-compose exec web chown -R www-data:www-data /var/www/html
    
    # Set proper permissions
    docker-compose exec web chmod -R 755 /var/www/html/public
    docker-compose exec web chmod -R 777 /var/www/html/logs
    docker-compose exec web chmod -R 777 /var/www/html/uploads
    docker-compose exec web chmod -R 777 /var/www/html/cache
    docker-compose exec web chmod -R 777 /var/www/html/sessions
    
    log_success "File permissions set correctly"
}

# Show deployment summary
show_summary() {
    echo ""
    echo "✅ Deployment completed successfully!"
    echo "================================================"
    echo ""
    
    # Get domain from .env
    DOMAIN=$(grep APP_URL .env | cut -d '=' -f2)
    
    echo "🌐 Website URL: $DOMAIN"
    echo "📊 phpMyAdmin: http://localhost:8080"
    echo "🗄️  Database: localhost:3306"
    echo "🔴 Redis: localhost:6379"
    echo ""
    echo "📋 Service Status:"
    docker-compose ps
    echo ""
    
    # Test website
    if curl -s -o /dev/null -w "%{http_code}" http://localhost | grep -q 200; then
        log_success "Website is responding correctly"
    else
        log_warning "Website might not be fully ready yet"
    fi
    
    echo ""
    echo "📖 Useful commands:"
    echo "   docker-compose logs -f        # View logs"
    echo "   docker-compose restart        # Restart services"
    echo "   docker-compose down           # Stop services"
    echo "   docker-compose exec web bash  # Access web container"
    echo ""
}

# Error handling
cleanup() {
    if [ $? -ne 0 ]; then
        log_error "Deployment failed!"
        echo ""
        echo "🔧 Troubleshooting:"
        echo "   1. Check Docker logs: docker-compose logs"
        echo "   2. Verify .env configuration"
        echo "   3. Ensure ports 80, 443, 3306, 6379 are available"
        echo "   4. Check system resources (disk space, memory)"
        echo ""
    fi
}

trap cleanup EXIT

# Main deployment process
main() {
    check_docker
    setup_environment
    setup_directories
    deploy_containers
    wait_for_services
    set_permissions
    setup_ssl
    show_summary
    
    log_success "RisolviAmoSubito.it is now live! 🎉"
}

# Run main function
main