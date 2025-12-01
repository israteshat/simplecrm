# Docker Deployment Guide for SimpleCRM

Complete guide to deploy SimpleCRM using Docker on a Linux machine.

## 📋 Prerequisites

- Linux server (Ubuntu 20.04+ recommended)
- Docker installed (version 20.10+)
- Docker Compose installed (version 2.0+)
- At least 2GB RAM
- At least 10GB disk space
- Domain name (optional, for production)

## 🚀 Quick Start

### 1. Install Docker and Docker Compose

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Add user to docker group (to run without sudo)
sudo usermod -aG docker $USER
newgrp docker

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify installation
docker --version
docker-compose --version
```

### 2. Clone/Upload Your Project

```bash
# Option 1: Clone from GitHub
git clone https://github.com/yourusername/simplecrm.git
cd simplecrm

# Option 2: Upload via SCP
# scp -r /path/to/simplecrm user@your-server:/home/user/
```

### 3. Configure Environment Variables

```bash
# Copy example env file
cp .env.example .env

# Edit environment variables
nano .env
```

**Important variables to set:**
```env
# Change these!
DB_ROOT_PASSWORD=strong-root-password-here
DB_PASS=strong-db-password-here
JWT_SECRET=your-super-secret-jwt-key-min-32-chars

# Update these with your actual values
GOOGLE_CLIENT_ID=your-google-client-id
GOOGLE_CLIENT_SECRET=your-google-client-secret
GOOGLE_AI_API_KEY=your-gemini-api-key

# For production, update URLs
FRONTEND_URL=https://yourdomain.com
VITE_API_BASE=https://api.yourdomain.com/api
VITE_SOCKET_URL=https://api.yourdomain.com
```

### 4. Build and Start Containers

```bash
# Build images
docker-compose build

# Start all services
docker-compose up -d

# View logs
docker-compose logs -f

# Check status
docker-compose ps
```

### 5. Run Database Migrations

```bash
# Wait for MySQL to be ready (about 30 seconds)
sleep 30

# Run migrations via MySQL container
docker-compose exec mysql mysql -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} < /docker-entrypoint-initdb.d/schema.sql

# Or manually via docker exec
docker-compose exec mysql bash
mysql -u root -p
# Then run SQL files manually
```

**Or use the automated script:**
```bash
# Create migration script
cat > run-migrations.sh << 'EOF'
#!/bin/bash
DB_ROOT_PASS=$(grep DB_ROOT_PASSWORD .env | cut -d '=' -f2)
DB_NAME=$(grep DB_NAME .env | cut -d '=' -f2)

echo "Running migrations..."
docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/simplecrm_schema.sql
docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/multi_tenant_schema.sql
docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASS} ${DB_NAME} < backend/sql/chatbot_schema.sql
echo "Migrations complete!"
EOF

chmod +x run-migrations.sh
./run-migrations.sh
```

### 6. Seed Initial Data (Optional)

```bash
docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} < backend/sql/seed_data.sql
docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} < backend/sql/seed_users.sql
```

### 7. Access Your Application

- **Frontend**: http://your-server-ip:3000
- **Backend API**: http://your-server-ip:4000
- **Health Check**: http://your-server-ip:4000/

## 🔧 Common Commands

### View Logs
```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f backend
docker-compose logs -f frontend
docker-compose logs -f mysql
```

### Restart Services
```bash
# Restart all
docker-compose restart

# Restart specific service
docker-compose restart backend
```

### Stop Services
```bash
# Stop all
docker-compose stop

# Stop and remove containers
docker-compose down

# Stop, remove containers and volumes (⚠️ deletes database!)
docker-compose down -v
```

### Update Application
```bash
# Pull latest code
git pull

# Rebuild and restart
docker-compose up -d --build

# Or rebuild specific service
docker-compose up -d --build backend
```

### Access Containers
```bash
# Backend container
docker-compose exec backend sh

# MySQL container
docker-compose exec mysql bash
mysql -u root -p

# Frontend container
docker-compose exec frontend sh
```

### Backup Database
```bash
# Create backup
docker-compose exec mysql mysqldump -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} > backup_$(date +%Y%m%d_%H%M%S).sql

# Restore backup
docker-compose exec -T mysql mysql -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} < backup_file.sql
```

## 🌐 Production Setup with Nginx Reverse Proxy

### 1. Install Nginx

```bash
sudo apt install nginx -y
```

### 2. Configure Nginx

```bash
sudo nano /etc/nginx/sites-available/simplecrm
```

Add configuration:
```nginx
# Frontend
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;

    location / {
        proxy_pass http://localhost:3000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;
    }
}

# Backend API
server {
    listen 80;
    server_name api.yourdomain.com;

    location / {
        proxy_pass http://localhost:4000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

### 3. Enable Site and Restart Nginx

```bash
sudo ln -s /etc/nginx/sites-available/simplecrm /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

### 4. Setup SSL with Let's Encrypt

```bash
# Install Certbot
sudo apt install certbot python3-certbot-nginx -y

# Get SSL certificate
sudo certbot --nginx -d yourdomain.com -d www.yourdomain.com -d api.yourdomain.com

# Auto-renewal is set up automatically
```

### 5. Update Environment Variables

Update `.env`:
```env
FRONTEND_URL=https://yourdomain.com
VITE_API_BASE=https://api.yourdomain.com/api
VITE_SOCKET_URL=https://api.yourdomain.com
```

Rebuild frontend:
```bash
docker-compose up -d --build frontend
```

## 🔒 Security Best Practices

### 1. Firewall Setup

```bash
# Install UFW
sudo apt install ufw -y

# Allow SSH
sudo ufw allow 22/tcp

# Allow HTTP/HTTPS
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp

# Enable firewall
sudo ufw enable
```

### 2. Secure MySQL

- Change default passwords
- Don't expose MySQL port (3306) to public
- Use strong passwords
- Regular backups

### 3. Environment Variables

- Never commit `.env` file
- Use strong secrets
- Rotate secrets regularly

### 4. Container Security

```bash
# Keep images updated
docker-compose pull
docker-compose up -d

# Remove unused images
docker image prune -a
```

## 📊 Monitoring

### View Resource Usage

```bash
# Container stats
docker stats

# Disk usage
docker system df
```

### Health Checks

All services have health checks configured. Check status:
```bash
docker-compose ps
```

## 🐛 Troubleshooting

### Issue: Containers won't start

```bash
# Check logs
docker-compose logs

# Check if ports are in use
sudo netstat -tulpn | grep -E '3000|4000|3306'

# Restart Docker
sudo systemctl restart docker
```

### Issue: Database connection errors

```bash
# Check MySQL is running
docker-compose ps mysql

# Check MySQL logs
docker-compose logs mysql

# Test connection
docker-compose exec mysql mysql -u root -p
```

### Issue: Frontend can't connect to backend

- Check `VITE_API_BASE` in `.env`
- Rebuild frontend: `docker-compose up -d --build frontend`
- Check backend is accessible: `curl http://localhost:4000`

### Issue: WebSocket not working

- Ensure backend port is accessible
- Check `VITE_SOCKET_URL` in `.env`
- Check firewall rules
- Verify CORS settings in backend

### Issue: Out of disk space

```bash
# Clean up Docker
docker system prune -a --volumes

# Check disk usage
df -h
```

## 🔄 Update Process

```bash
# 1. Pull latest code
git pull

# 2. Backup database
docker-compose exec mysql mysqldump -u root -p${DB_ROOT_PASSWORD} ${DB_NAME} > backup.sql

# 3. Rebuild and restart
docker-compose up -d --build

# 4. Run any new migrations
./run-migrations.sh

# 5. Verify everything works
docker-compose ps
curl http://localhost:4000
```

## 📝 Production Checklist

- [ ] Strong passwords set in `.env`
- [ ] JWT_SECRET is unique and secure
- [ ] Database backups configured
- [ ] SSL certificate installed
- [ ] Firewall configured
- [ ] Domain DNS configured
- [ ] Environment variables updated for production
- [ ] Monitoring set up
- [ ] Log rotation configured
- [ ] Regular backup schedule

## 🚀 Performance Optimization

### 1. Increase MySQL Performance

Edit `docker-compose.yml` MySQL service:
```yaml
mysql:
  command: --innodb-buffer-pool-size=512M --max-connections=200
```

### 2. Enable Nginx Caching

Add to nginx config:
```nginx
proxy_cache_path /var/cache/nginx levels=1:2 keys_zone=my_cache:10m;
```

### 3. Use Docker Resource Limits

Edit `docker-compose.yml`:
```yaml
services:
  backend:
    deploy:
      resources:
        limits:
          cpus: '1'
          memory: 1G
```

## 📚 Additional Resources

- [Docker Documentation](https://docs.docker.com/)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Nginx Documentation](https://nginx.org/en/docs/)
- [Let's Encrypt Documentation](https://letsencrypt.org/docs/)

## 🆘 Support

If you encounter issues:
1. Check logs: `docker-compose logs`
2. Verify environment variables
3. Check container status: `docker-compose ps`
4. Review this guide's troubleshooting section

Good luck with your deployment! 🎉

