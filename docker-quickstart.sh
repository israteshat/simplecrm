#!/bin/bash

# Quick start script for Docker deployment

set -e

echo "🐳 SimpleCRM Docker Quick Start"
echo "================================"
echo ""

# Check if .env exists
if [ ! -f .env ]; then
    echo "📝 Creating .env file from example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        echo "✅ .env file created. Please edit it with your configuration!"
        echo ""
        echo "⚠️  IMPORTANT: Edit .env file before continuing!"
        echo "   nano .env"
        echo ""
        read -p "Press Enter after editing .env file..."
    else
        echo "❌ .env.example not found!"
        exit 1
    fi
fi

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed!"
    echo "   Install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose is not installed!"
    echo "   Install Docker Compose: https://docs.docker.com/compose/install/"
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Build images
echo "🔨 Building Docker images..."
docker-compose build

echo ""
echo "🚀 Starting containers..."
docker-compose up -d

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if MySQL is ready
echo "🔍 Checking MySQL..."
until docker-compose exec -T mysql mysqladmin ping -h localhost --silent 2>/dev/null; do
    echo "   Waiting for MySQL..."
    sleep 2
done
echo "✅ MySQL is ready!"

echo ""
echo "📝 Running database migrations..."
./run-migrations.sh

echo ""
echo "✅ Setup complete!"
echo ""
echo "📊 Container status:"
docker-compose ps

echo ""
echo "🌐 Access your application:"
echo "   Frontend: http://localhost:3000"
echo "   Backend:  http://localhost:4000"
echo ""
echo "📋 Useful commands:"
echo "   View logs:    docker-compose logs -f"
echo "   Stop:         docker-compose stop"
echo "   Restart:      docker-compose restart"
echo "   Remove:       docker-compose down"
echo ""
echo "🎉 Happy coding!"

