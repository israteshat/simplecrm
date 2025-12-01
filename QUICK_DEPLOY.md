# Quick Deploy Guide - Render + PlanetScale + Vercel

The **fastest way** to deploy SimpleCRM for free with MySQL support.

## 🎯 What You'll Use

- **Backend**: Render (free tier)
- **Database**: PlanetScale (MySQL, free tier) - **No conversion needed!**
- **Frontend**: Vercel (free tier)

## ⚡ Quick Steps

### 1. Set Up PlanetScale Database (5 minutes)

1. Go to [planetscale.com](https://planetscale.com) → Sign up
2. Click **"Create database"**
3. Name: `simplecrm`
4. Plan: **Hobby** (free)
5. Region: Choose closest to you
6. Click **"Create database"**
7. Go to **"Connect"** tab
8. Copy these values (you'll need them):
   - Host
   - Username
   - Password
   - Database name

### 2. Deploy Backend to Render (10 minutes)

1. Go to [render.com](https://render.com) → Sign up with GitHub
2. Click **"New"** → **"Web Service"**
3. Connect your GitHub repository
4. Configure:
   - **Name**: `simplecrm-backend`
   - **Root Directory**: `backend`
   - **Environment**: `Node`
   - **Build Command**: `npm install`
   - **Start Command**: `npm start`
   - **Plan**: **Free**
5. Click **"Advanced"** → Add environment variables:
   ```
   NODE_ENV=production
   PORT=4000
   JWT_SECRET=your-random-secret-key-min-32-characters-long
   DB_HOST=<from-planetscale>
   DB_PORT=3306
   DB_USER=<from-planetscale>
   DB_PASS=<from-planetscale>
   DB_NAME=<from-planetscale>
   GOOGLE_CLIENT_ID=your-google-client-id
   GOOGLE_CLIENT_SECRET=your-google-client-secret
   GOOGLE_AI_API_KEY=your-gemini-api-key
   GEMINI_MODEL=gemini-2.5-flash
   FRONTEND_URL=https://your-app.vercel.app
   ```
6. Click **"Create Web Service"**
7. Wait for deployment (5-10 minutes)
8. Copy your backend URL: `https://simplecrm-backend.onrender.com`

### 3. Run Database Migrations (5 minutes)

1. Go to PlanetScale dashboard
2. Click on your database → **"Console"** tab
3. Copy content from `sql/schema.sql` and paste → Run
4. Copy content from `sql/multi_tenant_schema.sql` and paste → Run
5. Copy content from `sql/chatbot_schema.sql` and paste → Run
6. (Optional) Copy content from `sql/seed_data.sql` and paste → Run
7. (Optional) Copy content from `sql/seed_users.sql` and paste → Run

### 4. Deploy Frontend to Vercel (5 minutes)

1. Go to [vercel.com](https://vercel.com) → Sign up with GitHub
2. Click **"Add New"** → **"Project"**
3. Import your GitHub repository
4. Configure:
   - **Root Directory**: `frontend`
   - **Framework Preset**: Vite (auto-detected)
   - **Build Command**: `npm run build` (auto-filled)
   - **Output Directory**: `dist` (auto-filled)
5. Click **"Environment Variables"** → Add:
   ```
   VITE_API_BASE=https://simplecrm-backend.onrender.com/api
   VITE_SOCKET_URL=https://simplecrm-backend.onrender.com
   ```
6. Click **"Deploy"**
7. Wait for deployment (2-3 minutes)
8. Copy your frontend URL: `https://your-app.vercel.app`

### 5. Update Backend CORS (2 minutes)

1. Go back to Render dashboard
2. Go to your backend service → **"Environment"**
3. Update `FRONTEND_URL` to your Vercel URL:
   ```
   FRONTEND_URL=https://your-app.vercel.app
   ```
4. Render will auto-redeploy

### 6. Test Your App (5 minutes)

1. Visit your Vercel frontend URL
2. Try to register/login
3. Test the chatbot
4. Check browser console for errors

## ✅ Done!

Your app is now live! 🎉

## 🔧 Troubleshooting

### Backend not starting?
- Check Render logs: Dashboard → Your service → Logs
- Verify all environment variables are set
- Check database connection details

### Database connection errors?
- Verify PlanetScale connection details
- Check if database is active in PlanetScale dashboard
- Ensure migrations have been run

### Frontend can't connect to backend?
- Check `VITE_API_BASE` is set correctly
- Verify backend URL is accessible
- Check CORS settings in backend

### WebSocket not working?
- Verify `VITE_SOCKET_URL` is set
- Check Render supports WebSockets (it does!)
- Check browser console for connection errors

## 📝 Notes

- **Render free tier**: Spins down after 15 min inactivity (first request may be slow)
- **PlanetScale free tier**: 1 database, 1GB storage (plenty for development)
- **Vercel free tier**: Unlimited deployments, 100GB bandwidth

## 🚀 Next Steps

- Set up custom domain (optional)
- Configure Google OAuth redirect URLs
- Set up database backups
- Monitor usage to stay within free tiers

Good luck! 🎉

