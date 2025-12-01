# Chatbot Setup Guide

## Phase 1: Basic Chat Widget + AI Integration

### Prerequisites

1. **Google Gemini API Key** (Free)
   - Go to [Google AI Studio](https://makersuite.google.com/app/apikey)
   - Sign in with your Google account
   - Click "Create API Key"
   - Copy the API key

2. **Database Migration**
   ```bash
   mysql -u root -p simplecrm < backend/sql/chatbot_schema.sql
   ```

### Environment Variables

Add to `backend/.env`:
```env
# Google Gemini AI (Free)
GOOGLE_AI_API_KEY=your_gemini_api_key_here
# OR
GEMINI_API_KEY=your_gemini_api_key_here

# Frontend URL (for CORS)
FRONTEND_URL=http://localhost:5173
```

### Installation

1. **Backend Dependencies** (already installed)
   ```bash
   cd backend
   npm install
   ```

2. **Frontend Dependencies** (already installed)
   ```bash
   cd frontend
   npm install
   ```

### Running the Application

1. **Start Backend**
   ```bash
   cd backend
   npm run dev
   ```
   You should see:
   - `Server listening on 4000`
   - `WebSocket chat server initialized`

2. **Start Frontend**
   ```bash
   cd frontend
   npm run dev
   ```

3. **Access Chatbot Demo**
   - Login to the application
   - Navigate to `/chatbot-demo`
   - Click "Open Chat Widget"

### Testing the Chatbot

1. **Test Ticket Lookup**
   - First, create a ticket via the CRM
   - In chat, ask: "What's the status of ticket #1?"
   - Bot should fetch and display ticket details

2. **Test Ticket Creation**
   - Ask: "I need help with login issues"
   - Bot should create a ticket and respond with ticket ID

3. **Test General Queries**
   - Ask: "Hello" or "What can you help me with?"
   - Bot should respond conversationally

### Features Implemented

✅ **React Chat Widget**
- Real-time messaging via WebSocket
- Message history
- Typing indicators
- Voice recording button (UI ready)

✅ **WebSocket Server**
- Real-time bidirectional communication
- Session management
- Message queuing

✅ **AI Integration (Google Gemini)**
- Natural language understanding
- Intent extraction (ticket_lookup, create_ticket, etc.)
- Entity recognition (ticket IDs, priorities)
- Context-aware responses

✅ **CRM Data Fetching**
- Ticket lookup by ID
- Ticket creation from chat
- Customer context awareness

### File Structure

```
frontend/src/components/Chatbot/
├── ChatWidget.jsx      # Main chat component
├── MessageList.jsx     # Message display
└── MessageInput.jsx    # Input + voice button

backend/
├── routes/
│   └── chat.js         # Chat API endpoints
├── services/
│   └── aiService.js    # Google Gemini integration
└── websocket/
    └── chatServer.js   # WebSocket server
```

### API Endpoints

- `POST /api/chat/sessions` - Create chat session
- `GET /api/chat/sessions/:id/messages` - Get message history
- `GET /api/chat/tickets/:id` - Get ticket (for customer)
- `POST /api/chat/tickets` - Create ticket from chat
- `POST /api/chat/voice` - Upload voice message
- `WebSocket /` - Real-time messaging

### Next Steps (Phase 2)

- [ ] Voice message transcription
- [ ] Enhanced AI prompts
- [ ] Knowledge base integration
- [ ] Conference call integration

### Troubleshooting

**Chat not connecting:**
- Check WebSocket server is running
- Verify CORS settings in `chatServer.js`
- Check browser console for errors

**AI not responding:**
- Verify `GOOGLE_AI_API_KEY` is set
- Check backend logs for API errors
- Ensure API key has Gemini API access

**Messages not saving:**
- Verify database migration ran successfully
- Check database connection
- Review backend logs

