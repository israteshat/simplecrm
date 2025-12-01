#!/bin/bash

# Script to run database migrations in Docker

# Load environment variables
if [ -f .env ]; then
    export $(cat .env | grep -v '^#' | xargs)
fi

DB_ROOT_PASS=${DB_ROOT_PASSWORD:-rootpassword}
DB_NAME=${DB_NAME:-simplecrm}

echo "🚀 Running database migrations..."
echo "Database: $DB_NAME"

# Wait for MySQL to be ready
echo "⏳ Waiting for MySQL to be ready..."
until docker-compose exec -T mysql mysqladmin ping -h localhost --silent; do
    echo "Waiting for MySQL..."
    sleep 2
done

echo "✅ MySQL is ready!"

# Run migrations
echo "📝 Running schema migrations..."

if [ -f "backend/sql/simplecrm_schema.sql" ]; then
    echo "  - Running simplecrm_schema.sql"
    docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/simplecrm_schema.sql
fi

if [ -f "backend/sql/multi_tenant_schema.sql" ]; then
    echo "  - Running multi_tenant_schema.sql"
    docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/multi_tenant_schema.sql
fi

if [ -f "backend/sql/chatbot_schema.sql" ]; then
    echo "  - Running chatbot_schema.sql"
    docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/chatbot_schema.sql
fi

if [ -f "backend/sql/schema_updates.sql" ]; then
    echo "  - Running schema_updates.sql"
    docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/schema_updates.sql
fi

echo "✅ Migrations complete!"

# Ask if user wants to seed data
read -p "Do you want to seed initial data? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🌱 Seeding initial data..."
    
    if [ -f "backend/sql/seed_data.sql" ]; then
        echo "  - Running seed_data.sql"
        docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/seed_data.sql
    fi
    
    if [ -f "backend/sql/seed_users.sql" ]; then
        echo "  - Running seed_users.sql"
        docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/seed_users.sql
    fi
    
    echo "✅ Data seeding complete!"
fi

echo "🎉 All done!"

