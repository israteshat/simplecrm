require('dotenv').config();
const express = require('express');
const cors = require('cors');
const bodyParser = require('body-parser');
const authRoutes = require('./routes/auth');
const mcpRoutes = require('./routes/mcp');
const contacts = require('./routes/contacts');
const deals = require('./routes/deals');
const tasks = require('./routes/tasks');
const tickets = require('./routes/tickets');
const pipelineStages = require('./routes/pipeline_stages');
const importRoutes = require('./routes/import');
const knowledgeBase = require('./routes/knowledge_base');
const activity = require('./routes/activity');
const googleRoutes = require('./routes/google');
const tenants = require('./routes/tenants');
const chatRoutes = require('./routes/chat');
const authMiddleware = require('./middleware/auth');
const { setTenantContext, requireTenant } = require('./middleware/tenant');
const { initializeChatServer } = require('./websocket/chatServer');

const app = express();
app.use(cors());
app.use(bodyParser.json());

app.get('/', (req, res) => res.json({ msg: 'SimpleCRM API' }));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/mcp', mcpRoutes);
app.use('/api/tenants', tenants);
app.use('/api/chat', chatRoutes);

// All data routes require auth, tenant context, and tenant access
const tenantMiddleware = [authMiddleware.requireAuth, setTenantContext, requireTenant];
app.use('/api/contacts', ...tenantMiddleware, contacts);
app.use('/api/deals', ...tenantMiddleware, deals);
app.use('/api/tasks', ...tenantMiddleware, tasks);
app.use('/api/tickets', ...tenantMiddleware, tickets);
app.use('/api/pipeline-stages', ...tenantMiddleware, pipelineStages);
app.use('/api/import', ...tenantMiddleware, importRoutes);
app.use('/api/knowledge-base', ...tenantMiddleware, knowledgeBase);
app.use('/api/activity', ...tenantMiddleware, activity);
app.use('/api/google', ...tenantMiddleware, googleRoutes);

const PORT = process.env.PORT || 4000;
const server = app.listen(PORT, () => {
  console.log('Server listening on', PORT);
  // Initialize WebSocket server
  initializeChatServer(server);
  console.log('WebSocket chat server initialized');
});
