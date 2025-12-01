# SimpleCRM Scaffold

This archive contains three main folders:
- backend : Node.js + Express API with auth and MCP handler
- frontend: Vite + React + Tailwind minimal UI (welcome, login, register, dashboards)
- mobile  : Expo React Native minimal app (screens: welcome, login, register, dashboard)

## Run in VS Code (recommended)
1. Open this folder in VS Code.
2. Backend:
   - Open a terminal, `cd backend`
   - Copy `.env.example` to `.env` and adjust values
   - Run `npm install`
   - Run `npm run dev`
   - Create the database using `backend/sql/simplecrm_schema.sql` (via phpMyAdmin or mysql client)
3. Frontend:
   - Open a second terminal, `cd frontend`
   - Run `npm install`
   - Run `npm run dev` and open the URL shown (usually http://localhost:5173)
4. Mobile (optional):
   - `cd mobile`
   - `npm install`
   - `npx expo start`

## Notes
- This scaffold is intentionally minimal; fill in production-ready security, validations, and features later.
- Google Sign-In requires adding your client ID into backend `.env` and frontend Google button integration.

## Additional services added
- backend/routes: contacts, deals, tasks
- middleware: auth + role checks
- services/google_integration.js: placeholders for Gmail/Calendar
- telegram_bot/: microservice for Telegram bot (voice handling placeholder)

To run telegram bot: cd telegram_bot && npm install && TELEGRAM_TOKEN=your_token npm start

Google integrations require creating credentials in Google Cloud and implementing OAuth token storage.

## Google API Integration
- Endpoints:
  - GET /api/google/auth-url?scope=gmail,calendar  -> returns a Google consent URL for the logged-in user
  - POST /api/google/exchange  { code }  -> exchange code for tokens and store them for the user
  - GET /api/google/tokens -> check token existence
- Set env variables: GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET, GOOGLE_REDIRECT_URI
- Make sure redirect URI is registered in your Google Cloud OAuth credentials (e.g. http://localhost:4000/api/google/callback)
- After storing tokens, server can call Gmail/Calendar APIs using stored refresh tokens.
