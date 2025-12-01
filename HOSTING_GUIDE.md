# Free Hosting Guide for SimpleCRM

This guide covers multiple free hosting options for your SimpleCRM application.

## 🚀 Recommended: Railway (Easiest - Full Stack)

Railway is the easiest option as it supports both backend and database, plus WebSockets.

### Prerequisites
- GitHub account
- Railway account (free tier: $5 credit/month)

### Steps

#### 1. Prepare Your Repository
```bash
# Make sure your code is pushed to GitHub
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/yourusername/simplecrm.git
git push -u origin main
```

#### 2. Deploy Backend to Railway

1. Go to [railway.app](https://railway.app) and sign up with GitHub
2. Click "New Project" → "Deploy from GitHub repo"
3. Select your repository
4. Railway will auto-detect it's a Node.js app
5. Add environment variables:
   ```
   NODE_ENV=production
   PORT=4000
   JWT_SECRET=your-super-secret-jwt-key-here
   DB_HOST=your-db-host
   DB_PORT=3306
   DB_USER=your-db-user
   DB_PASS=your-db-password
   DB_NAME=simplecrm
   GOOGLE_CLIENT_ID=your-google-client-id
   GOOGLE_CLIENT_SECRET=your-google-client-secret
   GOOGLE_AI_API_KEY=your-gemini-api-key
   GEMINI_MODEL=gemini-2.5-flash
   FRONTEND_URL=https://your-frontend-domain.vercel.app
   ```

#### 3. Add MySQL Database

1. In Railway project, click "New" → "Database" → "MySQL"
2. Railway will create a MySQL database
3. Copy the connection details and update your backend environment variables:
   ```
   DB_HOST=<railway-provided-host>
   DB_PORT=3306
   DB_USER=<railway-provided-user>
   DB_PASS=<railway-provided-password>
   DB_NAME=railway
   ```

#### 4. Run Database Migrations

1. In Railway, go to your backend service
2. Click "Settings" → "Deploy" → "Add Deploy Command"
3. Add: `npm install && node -e "require('child_process').execSync('mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < sql/schema.sql', {stdio: 'inherit'})" || npm start`
4. Or manually run migrations via Railway's MySQL console

#### 5. Deploy Frontend to Vercel

1. Go to [vercel.com](https://vercel.com) and sign up with GitHub
2. Click "New Project" → Import your repository
3. Configure:
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
4. Add environment variables:
   ```
   VITE_API_BASE=https://your-backend.railway.app/api
   ```
5. Update `frontend/src/components/Chatbot/ChatWidget.jsx` and `CollapsibleChatWidget.jsx`:
   ```javascript
   const API_BASE = import.meta.env.VITE_API_BASE || 'http://localhost:4000/api';
   const SOCKET_URL = import.meta.env.VITE_SOCKET_URL || 'http://localhost:4000';
   ```

#### 6. Update CORS Settings

In `backend/server.js`, update CORS:
```javascript
app.use(cors({
  origin: process.env.FRONTEND_URL || 'https://your-app.vercel.app',
  credentials: true
}));
```

---

## 🎯 Alternative Option 1: Render (Free Tier)

### Backend on Render

1. Go to [render.com](https://render.com) and sign up
2. Click "New" → "Web Service"
3. Connect GitHub repo
4. Configure:
   - **Name**: `simplecrm-backend`
   - **Root Directory**: `backend`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Environment**: `Node`
5. Add environment variables (same as Railway)
6. **Note**: Free tier spins down after 15 min inactivity

### Database on Render

1. Click "New" → "PostgreSQL" (or MySQL if available)
2. Render provides connection string
3. Update `DB_HOST`, `DB_USER`, `DB_PASS`, `DB_NAME`

### Frontend on Vercel

Same as Railway option above.

---

## 🎯 Alternative Option 2: Fly.io (Good for WebSockets)

### Backend on Fly.io

1. Install Fly CLI: `curl -L https://fly.io/install.sh | sh`
2. Sign up: `fly auth signup`
3. Create `backend/fly.toml`:
   ```toml
   app = "simplecrm-backend"
   primary_region = "iad"

   [build]
     builder = "paketobuildpacks/builder:base"

   [env]
     PORT = "4000"
     NODE_ENV = "production"

   [[services]]
     internal_port = 4000
     protocol = "tcp"

     [[services.ports]]
       handlers = ["http", "tls"]
       port = 80

     [[services.ports]]
       handlers = ["tls", "http"]
       port = 443
   ```
4. Deploy: `cd backend && fly deploy`
5. Set secrets: `fly secrets set JWT_SECRET=xxx DB_HOST=xxx ...`

### Database on Fly.io

1. Create PostgreSQL: `fly postgres create`
2. Attach to app: `fly postgres attach <db-name> -a simplecrm-backend`

---

## 🎯 Alternative Option 3: Vercel + Supabase

### Frontend on Vercel
Same as above.

### Backend on Vercel (Serverless Functions)

**Note**: WebSockets won't work with serverless. You'll need to use a separate WebSocket service or modify the chat to use polling.

1. Convert API routes to Vercel serverless functions
2. Use Supabase for database (free tier available)
3. For WebSocket, use a separate service like Ably (free tier) or Pusher

---

## 📋 Environment Variables Checklist

### Backend (.env)
```env
NODE_ENV=production
PORT=4000
JWT_SECRET=your-super-secret-jwt-key-min-32-chars
DB_HOST=your-database-host
DB_PORT=3306
DB_USER=your-database-user
DB_PASS=your-database-password
DB_NAME=your-database-name
GOOGLE_CLIENT_ID=your-google-oauth-client-id
GOOGLE_CLIENT_SECRET=your-google-oauth-client-secret
GOOGLE_AI_API_KEY=your-gemini-api-key
GEMINI_MODEL=gemini-2.5-flash
FRONTEND_URL=https://your-frontend-domain.vercel.app
```

### Frontend (.env)
```env
VITE_API_BASE=https://your-backend.railway.app/api
VITE_SOCKET_URL=https://your-backend.railway.app
```

---

## 🔧 Post-Deployment Steps

### 1. Run Database Migrations

After deploying, run your SQL migrations:
```bash
# Option 1: Via Railway/Render console
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < sql/schema.sql
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < sql/multi_tenant_schema.sql
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < sql/chatbot_schema.sql

# Option 2: Via Railway/Render MySQL console (web interface)
# Copy and paste SQL files content
```

### 2. Seed Initial Data

```bash
# Run seed scripts via database console
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < sql/seed_data.sql
mysql -h $DB_HOST -u $DB_USER -p$DB_PASS $DB_NAME < sql/seed_users.sql
```

### 3. Update Frontend API URLs

Make sure all API calls use environment variables:
- Check `frontend/src/components/Chatbot/ChatWidget.jsx`
- Check `frontend/src/components/Chatbot/CollapsibleChatWidget.jsx`
- Check all API calls in pages

### 4. Test WebSocket Connection

1. Open browser console
2. Check for WebSocket connection errors
3. Test chat functionality

---

## 🆓 Free Tier Limits

### Railway
- $5 credit/month (usually enough for small apps)
- 500 hours compute time
- 5GB database storage

### Render
- Free tier spins down after 15 min inactivity
- 750 hours/month
- 1GB database storage

### Vercel
- Unlimited deployments
- 100GB bandwidth/month
- Serverless functions: 100GB-hours/month

### Fly.io
- 3 shared-cpu VMs
- 3GB persistent volume storage
- 160GB outbound data transfer

---

## 🐛 Common Issues & Solutions

### Issue: WebSocket not connecting
**Solution**: Ensure your hosting provider supports WebSockets (Railway, Render, Fly.io do). Vercel serverless doesn't support WebSockets.

### Issue: CORS errors
**Solution**: Update `FRONTEND_URL` in backend environment variables to match your frontend domain.

### Issue: Database connection fails
**Solution**: 
- Check database credentials
- Ensure database is accessible from your backend (not localhost-only)
- Verify firewall rules allow connections

### Issue: Environment variables not loading
**Solution**: 
- Restart your backend service after adding env vars
- Check variable names match exactly (case-sensitive)
- Verify `.env` file is not committed (should be in `.gitignore`)

---

## 📝 Quick Start Commands

```bash
# 1. Initialize Git (if not done)
git init
git add .
git commit -m "Initial commit"

# 2. Push to GitHub
git remote add origin https://github.com/yourusername/simplecrm.git
git push -u origin main

# 3. Deploy backend to Railway
# - Go to railway.app, connect repo, deploy

# 4. Deploy frontend to Vercel
# - Go to vercel.com, connect repo, set root to 'frontend'

# 5. Update environment variables in both platforms
# 6. Run database migrations
# 7. Test the application
```

---

## 🎉 Recommended Setup

**Best for beginners**: Railway (backend + DB) + Vercel (frontend)
- Easiest setup
- Good free tier
- Supports WebSockets
- Automatic deployments from GitHub

**Best for production**: Fly.io (backend + DB) + Vercel (frontend)
- Better performance
- More control
- Better for scaling

---

## 📚 Additional Resources

- [Railway Docs](https://docs.railway.app)
- [Vercel Docs](https://vercel.com/docs)
- [Render Docs](https://render.com/docs)
- [Fly.io Docs](https://fly.io/docs)

---

## ⚠️ Important Notes

1. **Free tiers have limits** - Monitor usage to avoid unexpected charges
2. **Database backups** - Set up regular backups (most platforms offer this)
3. **Environment variables** - Never commit `.env` files to Git
4. **SSL/HTTPS** - All platforms provide free SSL certificates
5. **Custom domains** - Most platforms allow custom domains (some free, some paid)

Good luck with your deployment! 🚀

