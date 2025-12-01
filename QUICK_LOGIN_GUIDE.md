# Quick Login Guide - Super Admin & All Users

## 🚀 Super Admin Login

### Credentials
- **Email:** `superadmin@simplecrm.com`
- **Password:** `superadmin123`

### Steps
1. Go to `http://localhost:5173/login` (or your frontend URL)
2. Select **any tenant** from the dropdown (super admin can use any tenant)
3. Enter email: `superadmin@simplecrm.com`
4. Enter password: `superadmin123`
5. Click "Login"
6. You'll be redirected to `/dashboard/admin`
7. Navigate to `/tenants` to manage all tenants

### Via API
```bash
curl -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "email": "superadmin@simplecrm.com",
    "password": "superadmin123",
    "tenant_slug": "default"
  }'
```

---

## 👔 Admin Users Login

### Default Tenant Admin
- **Email:** `admin@default.com`
- **Password:** `admin123`
- **Tenant Slug:** `default`

### Acme Corporation Admin
- **Email:** `admin@acme.com`
- **Password:** `admin123`
- **Tenant Slug:** `acme-corp`

### TechStart Inc Admin
- **Email:** `admin@techstart.com`
- **Password:** `admin123`
- **Tenant Slug:** `techstart`

### Global Solutions Admin
- **Email:** `admin@global.com`
- **Password:** `admin123`
- **Tenant Slug:** `global-solutions`

---

## 👤 Customer Users Login

### Default Tenant Customers
- `customer1@default.com` / `customer123` (tenant: `default`)
- `customer2@default.com` / `customer123` (tenant: `default`)

### Acme Corporation Customers
- `customer1@acme.com` / `customer123` (tenant: `acme-corp`)
- `customer2@acme.com` / `customer123` (tenant: `acme-corp`)

### TechStart Inc Customers
- `customer1@techstart.com` / `customer123` (tenant: `techstart`)
- `customer2@techstart.com` / `customer123` (tenant: `techstart`)

### Global Solutions Customers
- `customer1@global.com` / `customer123` (tenant: `global-solutions`)
- `customer2@global.com` / `customer123` (tenant: `global-solutions`)

---

## 📍 All Tenant Routes

### Frontend Routes
- `/login` - Login page
- `/register` - Registration page
- `/tenants` - Tenant management (Super Admin only)
- `/dashboard/admin` - Admin dashboard

### Backend API Routes

#### Authentication
- `GET /api/auth/tenants` - List all tenants (public)
- `POST /api/auth/login` - Login
- `POST /api/auth/register` - Register
- `POST /api/auth/google` - Google OAuth login

#### Tenant Management (Super Admin Only)
- `GET /api/tenants` - List all tenants with stats
- `GET /api/tenants/:id` - Get tenant details
- `POST /api/tenants` - Create tenant
- `PUT /api/tenants/:id` - Update tenant
- `DELETE /api/tenants/:id` - Delete tenant
- `GET /api/tenants/current/info` - Get current user's tenant

---

## 🔑 Quick Test Commands

### 1. Login as Super Admin
```bash
TOKEN=$(curl -s -X POST http://localhost:4000/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"superadmin@simplecrm.com","password":"superadmin123","tenant_slug":"default"}' \
  | jq -r '.token')

echo "Token: $TOKEN"
```

### 2. View All Tenants
```bash
curl -X GET http://localhost:4000/api/tenants \
  -H "Authorization: Bearer $TOKEN" | jq
```

### 3. View All Contacts (All Tenants)
```bash
curl -X GET http://localhost:4000/api/contacts \
  -H "Authorization: Bearer $TOKEN" | jq
```

### 4. View Contacts from Specific Tenant
```bash
curl -X GET "http://localhost:4000/api/contacts?tenant_id=2" \
  -H "Authorization: Bearer $TOKEN" | jq
```

### 5. Create New Tenant
```bash
curl -X POST http://localhost:4000/api/tenants \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{
    "name": "New Company",
    "slug": "new-company",
    "domain": "newcompany.com"
  }' | jq
```

---

## 📚 Full Documentation

See `TENANT_ROUTES.md` for complete API documentation and examples.

