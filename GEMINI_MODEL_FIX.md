# Gemini Model Fix

## Issue
All Gemini models were returning 404 errors because the model names were outdated.

## Solution
The script found that **`gemini-2.5-flash`** is available and working with your API key.

## Quick Fix

Add this to your `backend/.env`:

```env
GOOGLE_AI_API_KEY=your_api_key_here
GEMINI_MODEL=gemini-2.5-flash
```

## Available Models (from your API key)

Based on the model listing, these models are available:

1. ✅ **gemini-2.5-flash** - Recommended (fast, free tier)
2. ✅ gemini-2.5-pro - More capable
3. ✅ gemini-2.0-flash - Previous version
4. ✅ gemini-2.0-flash-001 - Stable version
5. ✅ gemini-2.5-flash-lite - Lite version
6. ✅ gemini-2.0-flash-lite - Lite version

## What Changed

The AI service now:
1. Automatically tries `gemini-2.5-flash` first (if no GEMINI_MODEL is set)
2. Falls back to other available models if the first one fails
3. Caches the working model for subsequent requests

## Test

After restarting your backend, the chatbot should work. The first message will show:
```
Trying model: gemini-2.5-flash
✅ Successfully initialized with model: gemini-2.5-flash
```

Then all subsequent messages will use this model without testing.

## Verify

Run this to see which models work:
```bash
cd backend
node scripts/list-gemini-models.js
```

