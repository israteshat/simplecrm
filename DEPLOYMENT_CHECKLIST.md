# Deployment Checklist

## ✅ Pre-Deployment Changes Made

1. **Centralized API Configuration**
   - Created `frontend/src/config/api.js` for centralized API URL management
   - Updated all frontend pages to use environment variables
   - All API calls now use `VITE_API_BASE` and `VITE_SOCKET_URL`

2. **Environment Variables Ready**
   - Frontend uses `VITE_API_BASE` and `VITE_SOCKET_URL`
   - Backend uses standard environment variables (see HOSTING_GUIDE.md)

## 📋 Before Deploying

### 1. Environment Variables Setup

**Frontend (Vercel/Railway):**
```env
VITE_API_BASE=https://your-backend.railway.app/api
VITE_SOCKET_URL=https://your-backend.railway.app
```

**Backend (Railway/Render):**
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
FRONTEND_URL=https://your-frontend.vercel.app
```

### 2. Database Setup

- [ ] Create database (MySQL/PostgreSQL)
- [ ] Run schema migrations:
  - `sql/schema.sql`
  - `sql/multi_tenant_schema.sql`
  - `sql/chatbot_schema.sql`
- [ ] Seed initial data (optional):
  - `sql/seed_data.sql`
  - `sql/seed_users.sql`

### 3. CORS Configuration

Update `backend/server.js` CORS settings:
```javascript
app.use(cors({
  origin: process.env.FRONTEND_URL || 'https://your-app.vercel.app',
  credentials: true
}));
```

### 4. Google OAuth Setup

- [ ] Update Google OAuth redirect URIs in Google Cloud Console
- [ ] Add production callback URLs:
  - `https://your-backend.railway.app/api/google/callback`

### 5. File Uploads

- [ ] Ensure `uploads/` directory is writable (or use cloud storage)
- [ ] Consider using cloud storage (AWS S3, Cloudinary) for production

## 🚀 Deployment Steps

1. **Push to GitHub**
   ```bash
   git add .
   git commit -m "Prepare for deployment"
   git push origin main
   ```

2. **Deploy Backend**
   - Follow HOSTING_GUIDE.md for your chosen platform
   - Set all environment variables
   - Run database migrations

3. **Deploy Frontend**
   - Deploy to Vercel/Netlify
   - Set environment variables
   - Update build settings if needed

4. **Test**
   - [ ] Test login/register
   - [ ] Test API calls
   - [ ] Test WebSocket connection (chatbot)
   - [ ] Test file uploads
   - [ ] Test Google OAuth

## 🔍 Post-Deployment Testing

- [ ] All API endpoints working
- [ ] WebSocket connection established
- [ ] Database queries working
- [ ] File uploads working
- [ ] Google OAuth working
- [ ] Chatbot AI responses working
- [ ] Multi-tenancy working

## 📝 Notes

- Free tiers have usage limits - monitor your usage
- Set up database backups
- Consider using a CDN for static assets
- Monitor error logs regularly

