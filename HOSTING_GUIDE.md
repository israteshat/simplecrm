# Free Hosting Guide for SimpleCRM

This guide covers **working free hosting options** for your SimpleCRM application with MySQL/PostgreSQL support.

## 🚀 Recommended Option 1: Render + PlanetScale (MySQL)

**Best for**: Keeping MySQL without conversion

### Backend on Render (Free Tier)

1. Go to [render.com](https://render.com) and sign up with GitHub
2. Click **"New"** → **"Web Service"**
3. Connect your GitHub repository
4. Configure:
   - **Name**: `simplecrm-backend`
   - **Root Directory**: `backend`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
5. Add environment variables (see below)
6. **Note**: Free tier spins down after 15 min inactivity (first request may be slow)

### Database: PlanetScale (MySQL - Free Tier)

1. Go to [planetscale.com](https://planetscale.com) and sign up
2. Click **"Create database"**
3. Choose **"Hobby"** plan (free)
4. Create database: `simplecrm`
5. Go to **"Connect"** → Copy connection details
6. Update backend environment variables:
   ```
   DB_HOST=<planetscale-host>
   DB_PORT=3306
   DB_USER=<planetscale-user>
   DB_PASS=<planetscale-password>
   DB_NAME=<planetscale-database>
   ```

### Frontend on Vercel (Free)

1. Go to [vercel.com](https://vercel.com) and sign up
2. Click **"New Project"** → Import repository
3. Configure:
   - **Root Directory**: `frontend`
   - **Build Command**: `npm run build`
   - **Output Directory**: `dist`
4. Add environment variables:
   ```
   VITE_API_BASE=https://simplecrm-backend.onrender.com/api
   VITE_SOCKET_URL=https://simplecrm-backend.onrender.com
   ```

---

## 🎯 Recommended Option 2: Render + Render PostgreSQL

**Best for**: Simple all-in-one solution (requires MySQL → PostgreSQL conversion)

### Backend on Render

Same as Option 1 above.

### Database: Render PostgreSQL (Free Tier)

1. In Render dashboard, click **"New"** → **"PostgreSQL"**
2. Configure:
   - **Name**: `simplecrm-db`
   - **Database**: `simplecrm`
   - **User**: Auto-generated
3. Copy connection string from Render dashboard
4. **Convert MySQL to PostgreSQL** (see conversion guide below)

### Frontend on Vercel

Same as Option 1 above.

---

## 🔄 MySQL to PostgreSQL Conversion

If using PostgreSQL, you need to convert your SQL files:

### Quick Conversion Steps

1. **Install conversion tool** (optional):
   ```bash
   npm install -g mysql-to-postgres
   ```

2. **Manual conversion** (recommended):
   - Replace `AUTO_INCREMENT` → `SERIAL` or `GENERATED ALWAYS AS IDENTITY`
   - Replace `DATETIME` → `TIMESTAMP`
   - Replace `TEXT` → Keep as `TEXT` (same)
   - Replace `ENUM` → `VARCHAR` with CHECK constraint
   - Remove backticks (PostgreSQL uses double quotes if needed)
   - Replace `ON DUPLICATE KEY UPDATE` → `ON CONFLICT ... DO UPDATE`

3. **Update backend code**:
   - Change `mysql2` to `pg` (PostgreSQL driver)
   - Update connection syntax
   - Update query syntax (minor differences)

### Alternative: Use PlanetScale (Keep MySQL)

Easier option - PlanetScale is MySQL-compatible, so no conversion needed!

---

## 🎯 Option 3: Fly.io (Full Stack - PostgreSQL)

**Best for**: More control, better performance

### Setup

1. **Install Fly CLI**:
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **Sign up**: `fly auth signup`

3. **Create backend app**:
   ```bash
   cd backend
   fly launch
   ```

4. **Create PostgreSQL database**:
   ```bash
   fly postgres create --name simplecrm-db
   fly postgres attach simplecrm-db
   ```

5. **Set environment variables**:
   ```bash
   fly secrets set JWT_SECRET=your-secret
   fly secrets set GOOGLE_AI_API_KEY=your-key
   # Database vars are auto-set by attach command
   ```

6. **Deploy**:
   ```bash
   fly deploy
   ```

### Frontend on Vercel

Same as above.

---

## 🎯 Option 4: Supabase (PostgreSQL + Backend Hosting)

**Best for**: Database + optional backend hosting

### Database: Supabase (Free Tier)

1. Go to [supabase.com](https://supabase.com) and sign up
2. Create new project
3. Get connection string from **Settings** → **Database**
4. Use connection details in your backend

### Backend: Render or Fly.io

Deploy backend to Render or Fly.io, connect to Supabase database.

### Frontend: Vercel

Same as above.

---

## 🎯 Option 5: Neon (PostgreSQL - Serverless)

**Best for**: Serverless PostgreSQL

1. Go to [neon.tech](https://neon.tech) and sign up
2. Create project
3. Get connection string
4. Use with Render/Fly.io backend

---

## 📋 Environment Variables

### Backend (Render/Fly.io)

```env
NODE_ENV=production
PORT=4000
JWT_SECRET=your-super-secret-jwt-key-min-32-chars
DB_HOST=your-database-host
DB_PORT=3306  # or 5432 for PostgreSQL
DB_USER=your-database-user
DB_PASS=your-database-password
DB_NAME=your-database-name
GOOGLE_CLIENT_ID=your-google-oauth-client-id
GOOGLE_CLIENT_SECRET=your-google-oauth-client-secret
GOOGLE_AI_API_KEY=your-gemini-api-key
GEMINI_MODEL=gemini-2.5-flash
FRONTEND_URL=https://your-frontend.vercel.app
```

### Frontend (Vercel)

```env
VITE_API_BASE=https://your-backend.onrender.com/api
VITE_SOCKET_URL=https://your-backend.onrender.com
```

---

## 🔧 Database Setup Steps

### For PlanetScale (MySQL)

1. **Run migrations via PlanetScale console**:
   - Go to PlanetScale dashboard
   - Click on your database
   - Go to **"Console"** tab
   - Copy and paste SQL from:
     - `sql/schema.sql`
     - `sql/multi_tenant_schema.sql`
     - `sql/chatbot_schema.sql`

2. **Seed data**:
   - Same console, paste:
     - `sql/seed_data.sql`
     - `sql/seed_users.sql`

### For Render PostgreSQL

1. **Connect via psql**:
   ```bash
   psql "postgresql://user:pass@host:5432/dbname"
   ```

2. **Run migrations**:
   ```sql
   \i sql/schema.sql
   \i sql/multi_tenant_schema.sql
   \i sql/chatbot_schema.sql
   ```

3. **Or use Render's database console** (web interface)

---

## 🆓 Free Tier Limits Comparison

| Platform | Database | Free Tier Limits |
|----------|----------|------------------|
| **PlanetScale** | MySQL | 1 database, 1GB storage, 1B rows/month |
| **Render** | PostgreSQL | 90 days free, then $7/month, 1GB storage |
| **Supabase** | PostgreSQL | 500MB database, 2GB bandwidth |
| **Neon** | PostgreSQL | 0.5GB storage, unlimited projects |
| **Fly.io** | PostgreSQL | 3GB storage, 3 VMs |

---

## 🚀 Quick Start: Render + PlanetScale (Recommended)

### Step 1: Set up PlanetScale Database

1. Sign up at [planetscale.com](https://planetscale.com)
2. Create database: `simplecrm`
3. Copy connection details

### Step 2: Deploy Backend to Render

1. Sign up at [render.com](https://render.com)
2. New → Web Service → Connect GitHub
3. Configure:
   - Root: `backend`
   - Build: `npm install`
   - Start: `npm start`
4. Add environment variables (use PlanetScale connection details)

### Step 3: Deploy Frontend to Vercel

1. Sign up at [vercel.com](https://vercel.com)
2. New Project → Import repo
3. Root: `frontend`
4. Add env vars with Render backend URL

### Step 4: Run Migrations

1. Go to PlanetScale dashboard → Console
2. Paste SQL from `sql/schema.sql`
3. Repeat for other SQL files

### Step 5: Test

1. Visit your Vercel frontend URL
2. Test login, API calls, WebSocket

---

## 🔄 Converting to PostgreSQL (If Needed)

If you choose PostgreSQL instead of PlanetScale, create a conversion script:

### Update `backend/db.js` for PostgreSQL:

```javascript
const { Pool } = require('pg');

const pool = new Pool({
  host: process.env.DB_HOST || 'localhost',
  port: process.env.DB_PORT || 5432,
  user: process.env.DB_USER || 'postgres',
  password: process.env.DB_PASS || 'postgres',
  database: process.env.DB_NAME || 'simplecrm',
  ssl: process.env.DB_SSL === 'true' ? { rejectUnauthorized: false } : false
});

module.exports = pool;
```

### Update `package.json`:

```json
"dependencies": {
  "pg": "^8.11.0"  // Instead of mysql2
}
```

### SQL Conversion Examples:

**MySQL:**
```sql
CREATE TABLE users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

**PostgreSQL:**
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

---

## 🐛 Common Issues

### Issue: Render free tier spins down
**Solution**: First request after 15 min may be slow. Consider upgrading or using Fly.io.

### Issue: PlanetScale connection limits
**Solution**: Free tier has connection limits. Use connection pooling.

### Issue: WebSocket not working
**Solution**: Ensure your hosting supports WebSockets (Render, Fly.io do. Vercel serverless doesn't).

### Issue: CORS errors
**Solution**: Update `FRONTEND_URL` in backend environment variables.

---

## ✅ Recommended Setup

**For beginners**: **Render (backend) + PlanetScale (MySQL) + Vercel (frontend)**
- Easiest setup
- No MySQL conversion needed
- All free tiers
- Supports WebSockets

**For production**: **Fly.io (backend + PostgreSQL) + Vercel (frontend)**
- Better performance
- More control
- Better for scaling

---

## 📚 Resources

- [Render Docs](https://render.com/docs)
- [PlanetScale Docs](https://planetscale.com/docs)
- [Vercel Docs](https://vercel.com/docs)
- [Fly.io Docs](https://fly.io/docs)
- [Supabase Docs](https://supabase.com/docs)

---

## 🎉 Summary

**Easiest path**: Use **PlanetScale for MySQL** (no conversion needed) + **Render for backend** + **Vercel for frontend**. All have generous free tiers and work well together!

Good luck with your deployment! 🚀
