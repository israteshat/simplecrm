# Tenant Routes & Super Admin Login Guide

## 🔐 How to Login as Super Admin

### Option 1: Via Frontend UI
1. Navigate to `/login` in your browser
2. **Email:** `superadmin@simplecrm.com`
3. **Password:** `superadmin123`
4. **Tenant Selection:** 
   - Super admin can select **any tenant** from the dropdown (or leave blank if only one tenant exists)
   - The system will allow login regardless of tenant selection for super admin
5. Click "Login"
6. You'll be redirected to `/dashboard/admin` with super admin privileges

### Option 2: Via API (Direct)
```bash
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "superadmin@simplecrm.com",
    "password": "superadmin123",
    "tenant_slug": "default"
  }'
```

**Response:**
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "user": {
    "id": 1,
    "email": "superadmin@simplecrm.com",
    "full_name": "Super Admin",
    "role": "admin",
    "tenant_id": null,
    "tenant_name": null,
    "tenant_slug": null,
    "is_super_admin": true
  }
}
```

### Important Notes:
- Super admin has `tenant_id = NULL` in the database
- Super admin can access **all tenants** regardless of which tenant they select during login
- Super admin can view/manage all tenants via the `/tenants` route
- When making API calls, super admin can optionally specify `?tenant_id=X` to filter data for a specific tenant

---

## 📍 All Tenant-Related Routes

### Frontend Routes

| Route | Component | Access | Description |
|-------|-----------|--------|-------------|
| `/login` | `Login.jsx` | Public | Login page with tenant selection |
| `/register` | `Register.jsx` | Public | Registration page (requires tenant selection) |
| `/tenants` | `TenantManagement.jsx` | Super Admin Only | Tenant management UI (CRUD operations) |
| `/dashboard/admin` | `AdminDashboard.jsx` | Admin/Super Admin | Admin dashboard (shows tenant info for super admin) |

### Backend API Routes

#### Authentication Routes (`/api/auth`)

| Method | Endpoint | Access | Description |
|--------|----------|--------|-------------|
| `GET` | `/api/auth/tenants` | Public | Get list of all tenants (for login dropdown) |
| `POST` | `/api/auth/login` | Public | Login with email, password, and optional tenant_slug |
| `POST` | `/api/auth/register` | Public | Register new user (requires tenant_id) |
| `POST` | `/api/auth/google` | Public | Google OAuth login (requires tenant_slug) |

**Login Request Body:**
```json
{
  "email": "superadmin@simplecrm.com",
  "password": "superadmin123",
  "tenant_slug": "default"  // Optional for super admin
}
```

**Register Request Body:**
```json
{
  "full_name": "John Doe",
  "username": "johndoe",
  "email": "john@example.com",
  "password": "password123",
  "phone": "+1-555-0100",
  "role": "customer",
  "tenant_id": 1  // Required
}
```

#### Tenant Management Routes (`/api/tenants`)

**All routes require authentication and super admin privileges.**

| Method | Endpoint | Description | Request Body |
|--------|----------|-------------|--------------|
| `GET` | `/api/tenants` | Get all tenants with stats | None |
| `GET` | `/api/tenants/:id` | Get single tenant details | None |
| `POST` | `/api/tenants` | Create new tenant | `{ name, slug, domain?, settings? }` |
| `PUT` | `/api/tenants/:id` | Update tenant | `{ name?, slug?, domain?, settings? }` |
| `DELETE` | `/api/tenants/:id` | Delete tenant (cannot delete 'default') | None |
| `GET` | `/api/tenants/current/info` | Get current user's tenant info | None |

**Example: Get All Tenants**
```bash
curl -X GET http://localhost:4000/api/tenants \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Response:**
```json
[
  {
    "id": 1,
    "name": "Default Tenant",
    "slug": "default",
    "domain": "default.simplecrm.com",
    "settings": null,
    "user_count": 5,
    "contact_count": 10,
    "deal_count": 3,
    "created_at": "2024-01-01T00:00:00.000Z",
    "updated_at": "2024-01-01T00:00:00.000Z"
  }
]
```

**Example: Create Tenant**
```bash
curl -X POST http://localhost:4000/api/tenants \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Company",
    "slug": "new-company",
    "domain": "newcompany.com"
  }'
```

**Example: Update Tenant**
```bash
curl -X PUT http://localhost:4000/api/tenants/2 \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Updated Company Name",
    "domain": "updated.com"
  }'
```

**Example: Delete Tenant**
```bash
curl -X DELETE http://localhost:4000/api/tenants/2 \
  -H "Authorization: Bearer YOUR_TOKEN"
```

**Example: Get Current Tenant Info**
```bash
curl -X GET http://localhost:4000/api/tenants/current/info \
  -H "Authorization: Bearer YOUR_TOKEN"
```

---

## 🔑 Super Admin Capabilities

### 1. View All Tenants
- Access `/tenants` route in frontend
- Or call `GET /api/tenants` API

### 2. View Data Across All Tenants
- By default, super admin sees **all data** from all tenants
- To filter by specific tenant, add `?tenant_id=X` to any data API call

**Example: View contacts from specific tenant**
```bash
# View all contacts (all tenants)
curl -X GET http://localhost:4000/api/contacts \
  -H "Authorization: Bearer YOUR_TOKEN"

# View contacts from tenant 2 only
curl -X GET "http://localhost:4000/api/contacts?tenant_id=2" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### 3. Create/Edit/Delete Tenants
- Use the `/tenants` UI or API endpoints
- Cannot delete the 'default' tenant

### 4. Manage Users Across Tenants
- Super admin can view users from all tenants
- Can create users for any tenant

---

## 🧪 Testing Super Admin Access

### Step 1: Login as Super Admin
```bash
# Via API
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "superadmin@simplecrm.com",
    "password": "superadmin123",
    "tenant_slug": "default"
  }'
```

Save the `token` from the response.

### Step 2: View All Tenants
```bash
curl -X GET http://localhost:4000/api/tenants \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Step 3: View All Data (All Tenants)
```bash
# All contacts from all tenants
curl -X GET http://localhost:4000/api/contacts \
  -H "Authorization: Bearer YOUR_TOKEN"

# All deals from all tenants
curl -X GET http://localhost:4000/api/deals \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Step 4: View Data from Specific Tenant
```bash
# Contacts from tenant 2 only
curl -X GET "http://localhost:4000/api/contacts?tenant_id=2" \
  -H "Authorization: Bearer YOUR_TOKEN"
```

### Step 5: Create New Tenant
```bash
curl -X POST http://localhost:4000/api/tenants \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Test Company",
    "slug": "test-company",
    "domain": "test.com"
  }'
```

---

## 📝 Tenant Slug Reference

When logging in, use these tenant slugs:

| Tenant Name | Slug | Domain |
|-------------|------|--------|
| Default Tenant | `default` | default.simplecrm.com |
| Acme Corporation | `acme-corp` | acme.simplecrm.com |
| TechStart Inc | `techstart` | techstart.simplecrm.com |
| Global Solutions | `global-solutions` | global.simplecrm.com |

---

## 🔒 Access Control Summary

| User Type | Can View | Can Manage Tenants | Tenant Context |
|-----------|----------|-------------------|----------------|
| **Super Admin** | All tenants | ✅ Yes | Can filter by `?tenant_id=X` |
| **Admin** | Own tenant only | ❌ No | Always scoped to their tenant |
| **Sales** | Own tenant only | ❌ No | Always scoped to their tenant |
| **Customer** | Own tenant only | ❌ No | Always scoped to their tenant |

---

## 🚨 Important Notes

1. **Super Admin Login:** Super admin can login with any tenant slug (or none), but the system will recognize them as super admin regardless.

2. **Tenant Isolation:** All data routes automatically filter by tenant_id for non-super-admin users.

3. **JWT Token:** The JWT token includes `tenant_id` and `is_super_admin` flags, which are used by middleware to determine access.

4. **Default Tenant:** The 'default' tenant cannot be deleted.

5. **Tenant Slug Format:** Must be lowercase, alphanumeric, with hyphens only (e.g., `my-company`, `acme-corp-2024`).

---

## 📚 Related Files

- Backend Routes: `backend/routes/tenants.js`
- Backend Routes: `backend/routes/auth.js`
- Frontend: `frontend/src/pages/TenantManagement.jsx`
- Frontend: `frontend/src/pages/Login.jsx`
- Middleware: `backend/middleware/tenant.js`
- Middleware: `backend/middleware/auth.js`

