# Chatbot Quick Start Guide

## 🚀 Phase 1 Implementation Complete!

### What's Built

✅ **React Chat Widget** - Beautiful, responsive chat interface
✅ **WebSocket Server** - Real-time bidirectional messaging
✅ **Google Gemini AI Integration** - Free AI for natural language understanding
✅ **CRM Data Integration** - Ticket lookup and creation
✅ **Voice Recording UI** - Ready for transcription (Phase 2)

## Quick Setup (5 minutes)

### 1. Get Free Google Gemini API Key

1. Visit: https://makersuite.google.com/app/apikey
2. Sign in with Google account
3. Click "Create API Key"
4. Copy the key

### 2. Configure Environment

Add to `backend/.env`:
```env
GOOGLE_AI_API_KEY=your_api_key_here
GEMINI_MODEL=gemini-2.5-flash  # Optional: defaults to gemini-2.5-flash
FRONTEND_URL=http://localhost:5173
```

**Note:** The default model `gemini-2.5-flash` is confirmed working and free. You can optionally specify a different model.

### 3. Run Database Migration

```bash
cd backend/sql
./run_chatbot_migration.sh
```

Or manually:
```bash
mysql -u root -p simplecrm < backend/sql/chatbot_schema.sql
```

### 4. Start Servers

**Terminal 1 - Backend:**
```bash
cd backend
npm run dev
```

**Terminal 2 - Frontend:**
```bash
cd frontend
npm run dev
```

### 5. Test the Chatbot

1. Login to the application
2. Navigate to: `http://localhost:5173/chatbot-demo`
3. Click "Open Chat Widget"
4. Try these queries:
   - "What's the status of ticket #1?"
   - "I need help with login issues"
   - "Hello, what can you help me with?"

## How It Works

### Customer Flow

1. **Customer opens chat widget** → Creates session
2. **Customer types message** → Sent via WebSocket
3. **Backend receives** → Processes with AI (Gemini)
4. **AI extracts intent** → ticket_lookup, create_ticket, etc.
5. **Backend fetches CRM data** → If needed (ticket details, etc.)
6. **AI generates response** → With CRM data context
7. **Response sent to customer** → Via WebSocket

### Example: Ticket Lookup

```
Customer: "What's ticket #12345?"
  ↓
AI extracts: { intent: 'ticket_lookup', ticket_id: 12345 }
  ↓
Backend queries: SELECT * FROM tickets WHERE id = 12345
  ↓
AI formats: "Your ticket #12345 'Login Issue' is In Progress..."
  ↓
Customer sees response
```

## File Structure

```
frontend/src/components/Chatbot/
├── ChatWidget.jsx      # Main component
├── MessageList.jsx     # Messages display
└── MessageInput.jsx    # Input + voice button

backend/
├── routes/chat.js      # REST API endpoints
├── services/aiService.js  # Gemini AI integration
└── websocket/chatServer.js  # WebSocket server
```

## Features

### ✅ Implemented
- Real-time chat via WebSocket
- Google Gemini AI integration (free)
- Intent extraction (ticket_lookup, create_ticket, etc.)
- Ticket lookup by ID
- Ticket creation from chat
- Message history
- Typing indicators
- Voice recording UI (ready for Phase 2)

### 🔜 Coming in Phase 2
- Voice message transcription
- Conference call integration
- Meeting notes generation
- Knowledge base search
- Enhanced AI prompts

## Testing

### Test Ticket Lookup
1. Create a ticket in the CRM first
2. In chat: "What's ticket #1?"
3. Bot should show ticket details

### Test Ticket Creation
1. In chat: "I need help with login"
2. Bot should create ticket and respond with ID

### Test General Chat
1. In chat: "Hello" or "Help me"
2. Bot should respond conversationally

## Troubleshooting

**"AI service is not configured"**
- Set `GOOGLE_AI_API_KEY` in `backend/.env`
- Restart backend server

**WebSocket not connecting**
- Check backend is running on port 4000
- Check browser console for errors
- Verify CORS settings

**Messages not saving**
- Run database migration
- Check database connection
- Review backend logs

## Next Steps

1. ✅ Get Gemini API key
2. ✅ Run migration
3. ✅ Start servers
4. ✅ Test chatbot
5. 🔜 Add voice transcription (Phase 2)
6. 🔜 Conference call integration (Phase 2)

## Support

See `CHATBOT_SETUP.md` for detailed documentation.

