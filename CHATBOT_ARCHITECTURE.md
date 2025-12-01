# In-App Customer Chatbot Architecture

## Overview

A web-based in-app chat widget that:
- Provides real-time chat interface for customers
- Integrates with external AI model (OpenAI, Gemini, Claude, etc.)
- Fetches CRM data (tickets, account info, orders) based on customer queries
- Supports voice messages with transcription
- Integrates with conference calls (Zoom, Google Meet, etc.) for meeting notes

## Architecture

```
Customer Browser
    ↓
React Chat Widget (Frontend)
    ↓
WebSocket/HTTP API (Backend)
    ↓
AI Service Layer ←→ CRM Database
    ↓                  ↓
Voice Transcription  Ticket/Contact Data
    ↓
Meeting Notes Service
```

## Components

### 1. Frontend Chat Widget
- React component embedded in customer portal
- Real-time messaging (WebSocket or polling)
- Voice message recording
- File upload support
- Typing indicators
- Message history

### 2. Backend Chat API
- WebSocket server for real-time communication
- REST endpoints for chat history, file uploads
- Message queue for AI processing
- Session management

### 3. AI Service Integration
- External AI API (OpenAI GPT-4, Google Gemini, Anthropic Claude)
- Intent extraction (ticket_lookup, account_info, create_ticket, etc.)
- Entity extraction (ticket_id, customer_email, etc.)
- Response generation with CRM data

### 4. CRM Data Service
- Ticket lookup by ID
- Customer account information
- Order/transaction history
- Knowledge base search
- Ticket creation from chat

### 5. Voice Processing
- Browser-based voice recording
- Upload to backend
- Transcription service (Whisper API, Google Speech-to-Text)
- Process transcribed text through AI

### 6. Conference Call Integration
- Webhook receiver for call events (Zoom, Google Meet, etc.)
- Audio recording download
- Transcription
- AI summarization and action item extraction
- Save to CRM activity timeline

## User Flow Examples

### Example 1: Customer Asks About Ticket

**Customer:** "What's the status of ticket #12345?"

1. **Frontend** sends message to backend via WebSocket
2. **Backend** receives message, adds to queue
3. **AI Service** processes:
   - Intent: `ticket_status_query`
   - Entity: `ticket_id = 12345`
4. **CRM Service** fetches ticket:
   ```sql
   SELECT * FROM tickets WHERE id = 12345 AND customer_id = ?
   ```
5. **AI Service** formats response:
   ```
   "Your ticket #12345 'Login Issue' is currently In Progress. 
   It's assigned to John Doe and has High priority. 
   Last update was 2 hours ago. Would you like more details?"
   ```
6. **Backend** sends response to frontend via WebSocket
7. **Frontend** displays message to customer

### Example 2: Voice Message

**Customer:** Sends voice message saying "I need help with my account"

1. **Frontend** records audio, uploads to backend
2. **Backend** receives audio file
3. **Transcription Service** converts to text:
   ```
   "I need help with my account"
   ```
4. **AI Service** processes text (same as text message)
5. **CRM Service** fetches customer account info
6. **AI Service** generates response
7. **Backend** sends response to customer

### Example 3: Conference Call Notes

**Scenario:** Customer and agent have a Zoom call

1. **Zoom Webhook** sends call ended event
2. **Backend** downloads recording
3. **Transcription Service** transcribes full call
4. **AI Service** processes:
   - Generates summary
   - Extracts action items
   - Identifies key decisions
5. **CRM Service** saves to activity timeline:
   ```json
   {
     "type": "meeting_notes",
     "ticket_id": 12345,
     "summary": "...",
     "action_items": [...],
     "participants": ["customer@email.com", "agent@company.com"]
   }
   ```
6. **Notification** sent to customer and agent

## Database Schema

```sql
-- Chat sessions
chat_sessions (
  id INT PRIMARY KEY,
  contact_id INT, -- Customer
  tenant_id INT,
  status VARCHAR(20), -- active, closed, waiting
  started_at DATETIME,
  last_message_at DATETIME,
  agent_id INT, -- If escalated to human
  FOREIGN KEY (contact_id) REFERENCES contacts(id)
)

-- Chat messages
chat_messages (
  id INT PRIMARY KEY,
  session_id INT,
  sender_type VARCHAR(20), -- customer, bot, agent
  sender_id INT, -- contact_id or user_id
  message_text TEXT,
  message_type VARCHAR(20), -- text, voice, file, system
  file_url VARCHAR(500),
  ai_intent VARCHAR(100),
  ai_entities JSON,
  created_at DATETIME,
  FOREIGN KEY (session_id) REFERENCES chat_sessions(id)
)

-- Voice messages
chat_voice_messages (
  id INT PRIMARY KEY,
  message_id INT,
  file_url VARCHAR(500),
  transcription TEXT,
  duration INT, -- seconds
  created_at DATETIME,
  FOREIGN KEY (message_id) REFERENCES chat_messages(id)
)

-- Conference call logs
conference_call_logs (
  id INT PRIMARY KEY,
  contact_id INT,
  agent_id INT,
  tenant_id INT,
  call_provider VARCHAR(50), -- zoom, google_meet, teams
  call_id VARCHAR(255),
  recording_url VARCHAR(500),
  transcription TEXT,
  summary TEXT,
  action_items JSON,
  duration INT,
  started_at DATETIME,
  ended_at DATETIME,
  FOREIGN KEY (contact_id) REFERENCES contacts(id)
)
```

## API Endpoints

### Chat Endpoints
- `POST /api/chat/sessions` - Create new chat session
- `GET /api/chat/sessions/:id` - Get session details
- `GET /api/chat/sessions/:id/messages` - Get message history
- `POST /api/chat/sessions/:id/messages` - Send message
- `POST /api/chat/sessions/:id/voice` - Upload voice message
- `WebSocket /ws/chat/:sessionId` - Real-time messaging

### AI/CRM Integration
- `POST /api/chat/ai/process` - Process message with AI
- `GET /api/chat/tickets/:id` - Get ticket (for customer)
- `POST /api/chat/tickets` - Create ticket from chat
- `GET /api/chat/customer/info` - Get customer account info

### Conference Calls
- `POST /api/chat/conference/webhook` - Receive call webhook
- `GET /api/chat/conference/:id` - Get call details
- `GET /api/chat/conference/:id/notes` - Get meeting notes

## Technology Stack Suggestions

### Frontend
- **React** - Chat widget component
- **Socket.io-client** - Real-time communication
- **Web Audio API** - Voice recording
- **React Speech Recognition** - Optional voice input

### Backend
- **Node.js/Express** - API server
- **Socket.io** - WebSocket server
- **Bull/Redis** - Message queue for AI processing
- **Multer** - File upload handling

### AI Integration
- **OpenAI API** - GPT-4 for chat
- **Google Gemini** - Alternative AI
- **Anthropic Claude** - Alternative AI
- **Whisper API** - Voice transcription

### Conference Integration
- **Zoom SDK/Webhooks** - Zoom integration
- **Google Meet API** - Google Meet integration
- **Microsoft Teams API** - Teams integration

## Implementation Phases

### Phase 1: Basic Chat Widget
- [ ] React chat component
- [ ] WebSocket real-time messaging
- [ ] Message history
- [ ] Basic AI integration
- [ ] Ticket lookup by ID

### Phase 2: AI Enhancement
- [ ] Intent extraction
- [ ] Entity recognition
- [ ] Context-aware responses
- [ ] Multi-turn conversations
- [ ] Knowledge base integration

### Phase 3: Voice Support
- [ ] Voice message recording
- [ ] Audio upload
- [ ] Transcription service
- [ ] Voice query processing

### Phase 4: Conference Integration
- [ ] Zoom webhook integration
- [ ] Call recording download
- [ ] Meeting transcription
- [ ] AI summarization
- [ ] Action item extraction
- [ ] CRM activity logging

### Phase 5: Advanced Features
- [ ] Sentiment analysis
- [ ] Proactive notifications
- [ ] Escalation to human agent
- [ ] Multi-language support
- [ ] Analytics dashboard

## Security Considerations

1. **Customer Authentication**
   - Link chat session to authenticated customer
   - Verify customer identity
   - Session tokens

2. **Data Privacy**
   - Only show customer their own data
   - Tenant isolation
   - Encrypt sensitive messages

3. **Rate Limiting**
   - Prevent abuse
   - Limit API calls per customer
   - Message rate limits

4. **File Upload Security**
   - File type validation
   - Size limits
   - Virus scanning

## Example AI Prompt Template

```
You are a customer support chatbot for [Company Name].

Customer Context:
- Name: {customer_name}
- Email: {customer_email}
- Account Status: {account_status}
- Recent Tickets: {recent_tickets}

Available Actions:
1. ticket_lookup(ticket_id) - Get ticket details
2. account_info() - Get customer account information
3. create_ticket(title, description) - Create new support ticket
4. search_knowledge_base(query) - Search help articles

Customer Message: "{message}"

Extract:
- Intent: [ticket_lookup|account_info|create_ticket|general_inquiry]
- Entities: {ticket_id, etc.}
- Response: [Generate helpful response using CRM data]
```

