# Docker Deployment - Quick Reference

## 🚀 Quick Start

```bash
# 1. Copy environment file
cp .env.example .env

# 2. Edit environment variables
nano .env

# 3. Run quick start script
./docker-quickstart.sh
```

Or manually:

```bash
# Build and start
docker-compose up -d --build

# Run migrations
./run-migrations.sh

# View logs
docker-compose logs -f
```

## 📋 Files Created

- `docker-compose.yml` - Orchestrates all services
- `backend/Dockerfile` - Backend container
- `frontend/Dockerfile` - Frontend container (multi-stage build)
- `frontend/nginx.conf` - Nginx configuration for frontend
- `run-migrations.sh` - Database migration script
- `docker-quickstart.sh` - Automated setup script

## 🔧 Services

- **MySQL**: Database (port 3306)
- **Backend**: API server (port 4000)
- **Frontend**: Web app (port 3000)

## 📝 Common Commands

```bash
# Start all services
docker-compose up -d

# Stop all services
docker-compose stop

# View logs
docker-compose logs -f

# Rebuild after code changes
docker-compose up -d --build

# Access MySQL
docker-compose exec mysql mysql -u root -p

# Backup database
docker-compose exec mysql mysqldump -u root -p simplecrm > backup.sql
```

## 🌐 Access

- Frontend: http://localhost:3000
- Backend: http://localhost:4000
- Health: http://localhost:4000/

## 📚 Full Documentation

See `DOCKER_DEPLOYMENT.md` for complete deployment guide including:
- Production setup with Nginx
- SSL certificate setup
- Security best practices
- Monitoring and troubleshooting

