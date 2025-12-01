# In-App Chatbot Implementation Plan

## Quick Start Guide

### 1. Database Setup
```bash
mysql -u root -p simplecrm < backend/sql/chatbot_schema.sql
```

### 2. Frontend Chat Widget Structure

```
frontend/src/components/Chatbot/
├── ChatWidget.jsx          # Main chat widget component
├── MessageList.jsx         # Message display
├── MessageInput.jsx        # Text input + voice button
├── VoiceRecorder.jsx       # Voice recording component
├── FileUpload.jsx          # File upload handler
└── ChatHistory.jsx         # Chat history sidebar
```

### 3. Backend API Structure

```
backend/
├── routes/
│   ├── chat.js             # Chat endpoints
│   ├── chat-ai.js          # AI processing endpoints
│   └── conference.js       # Conference call webhooks
├── services/
│   ├── aiService.js        # AI integration (OpenAI, Gemini, etc.)
│   ├── transcriptionService.js  # Voice transcription
│   └── conferenceService.js # Conference call processing
└── websocket/
    └── chatServer.js       # WebSocket server for real-time chat
```

## Key Features to Implement

### Feature 1: Basic Chat Widget
- React component with message bubbles
- Send/receive messages
- Real-time updates via WebSocket
- Message history loading

### Feature 2: AI Integration
- Connect to OpenAI/Gemini API
- Intent extraction
- Entity recognition (ticket IDs, etc.)
- Context-aware responses

### Feature 3: CRM Data Fetching
- Ticket lookup: "Show me ticket #12345"
- Account info: "What's my account status?"
- Create ticket: "I need help with login"
- Knowledge base search

### Feature 4: Voice Messages
- Record audio in browser
- Upload to backend
- Transcribe using Whisper/Google Speech
- Process transcribed text through AI

### Feature 5: Conference Call Integration
- Zoom webhook receiver
- Download call recordings
- Transcribe recordings
- AI summarization
- Save to CRM activity timeline

## Example Code Structure

### Frontend: ChatWidget.jsx
```jsx
import React, { useState, useEffect } from 'react';
import io from 'socket.io-client';

function ChatWidget({ contactId, tenantId }) {
  const [messages, setMessages] = useState([]);
  const [input, setInput] = useState('');
  const [socket, setSocket] = useState(null);

  useEffect(() => {
    // Connect to WebSocket
    const newSocket = io('http://localhost:4000', {
      query: { contactId, tenantId }
    });
    setSocket(newSocket);

    // Listen for messages
    newSocket.on('message', (message) => {
      setMessages(prev => [...prev, message]);
    });

    return () => newSocket.close();
  }, [contactId, tenantId]);

  const sendMessage = () => {
    if (input.trim()) {
      socket.emit('message', {
        text: input,
        contactId,
        tenantId
      });
      setInput('');
    }
  };

  return (
    <div className="chat-widget">
      <MessageList messages={messages} />
      <MessageInput 
        value={input}
        onChange={setInput}
        onSend={sendMessage}
        onVoice={handleVoice}
      />
    </div>
  );
}
```

### Backend: AI Service Example
```javascript
// services/aiService.js
const OpenAI = require('openai');

class AIService {
  constructor() {
    this.openai = new OpenAI({
      apiKey: process.env.OPENAI_API_KEY
    });
  }

  async processMessage(message, customerContext) {
    const prompt = this.buildPrompt(message, customerContext);
    
    const response = await this.openai.chat.completions.create({
      model: 'gpt-4',
      messages: [
        { role: 'system', content: this.getSystemPrompt() },
        { role: 'user', content: prompt }
      ],
      functions: this.getAvailableFunctions(),
      function_call: 'auto'
    });

    return this.parseResponse(response);
  }

  getAvailableFunctions() {
    return [
      {
        name: 'ticket_lookup',
        description: 'Get ticket details by ID',
        parameters: {
          type: 'object',
          properties: {
            ticket_id: { type: 'number' }
          }
        }
      },
      {
        name: 'create_ticket',
        description: 'Create a new support ticket',
        parameters: {
          type: 'object',
          properties: {
            title: { type: 'string' },
            description: { type: 'string' },
            priority: { type: 'string', enum: ['low', 'medium', 'high'] }
          }
        }
      }
    ];
  }
}
```

## Integration Points

### 1. Ticket Lookup Flow
```
Customer: "What's ticket #12345?"
  ↓
AI extracts: { intent: 'ticket_lookup', ticket_id: 12345 }
  ↓
Backend calls: GET /api/tickets/12345?contact_id={customer_id}
  ↓
CRM returns ticket data
  ↓
AI formats response: "Your ticket #12345 'Login Issue' is In Progress..."
  ↓
Send to customer via WebSocket
```

### 2. Voice Message Flow
```
Customer records voice
  ↓
Upload audio file to: POST /api/chat/voice
  ↓
Backend saves file, queues transcription
  ↓
Transcription service (Whisper API) processes
  ↓
Transcribed text → AI Service
  ↓
AI processes same as text message
  ↓
Response sent to customer
```

### 3. Conference Call Flow
```
Zoom call ends
  ↓
Zoom webhook: POST /api/conference/webhook
  ↓
Backend downloads recording
  ↓
Transcribe full recording
  ↓
AI Service:
  - Generate summary
  - Extract action items
  - Identify key decisions
  ↓
Save to conference_call_logs table
  ↓
Create activity timeline entry
  ↓
Notify customer and agent
```

## Environment Variables Needed

```env
# AI Service
OPENAI_API_KEY=sk-...
# OR
GOOGLE_AI_API_KEY=...
ANTHROPIC_API_KEY=...

# Transcription
WHISPER_API_KEY=...
# OR use OpenAI Whisper

# Conference Integration
ZOOM_WEBHOOK_SECRET=...
GOOGLE_MEET_CLIENT_ID=...
GOOGLE_MEET_CLIENT_SECRET=...

# File Storage
AWS_S3_BUCKET=...
# OR use local storage
```

## Next Steps

1. **Create database schema** ✅ (done)
2. **Build frontend chat widget** - React component
3. **Set up WebSocket server** - Real-time messaging
4. **Integrate AI service** - OpenAI/Gemini
5. **Implement CRM data fetching** - Ticket lookup, etc.
6. **Add voice support** - Recording + transcription
7. **Conference integration** - Webhook handlers
8. **Testing & refinement**

Would you like me to start implementing any specific component?

