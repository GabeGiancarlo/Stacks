# Local Development Setup Guide

This guide will walk you through setting up the Stacks app for local development.

## Prerequisites

Before starting, ensure you have:

- **Docker Desktop** installed and running
- **Node.js 18+** installed (for running migrations/seeds locally)
- **Xcode 15+** installed
- **iOS Simulator** or physical iOS device

## Step 1: Clone Repository

```bash
git clone https://github.com/GabeGiancarlo/Stacks
cd Stacks
```

## Step 2: Backend Setup

### 2.1 Navigate to Backend Directory

```bash
cd backend
```

### 2.2 Install Dependencies

```bash
npm install
```

### 2.3 Configure Environment

Copy the example environment file:

```bash
cp .env.example .env
```

The default `.env` values work with Docker Compose. You can modify them if needed:

```env
NODE_ENV=development
SERVER_PORT=8080
DB_HOST=mysql
DB_PORT=3306
DB_USER=stacks_user
DB_PASSWORD=secure_password
DB_NAME=stacks_db
JWT_SECRET=your-secret-key-change-in-production-min-32-chars
JWT_REFRESH_SECRET=your-refresh-secret-key-min-32-chars
JWT_EXPIRES_IN=15m
JWT_REFRESH_EXPIRES_IN=7d
CORS_ORIGIN=*
```

### 2.4 Start Docker Services

Start MySQL and backend services (from project root):

```bash
cd ..  # Go back to project root
docker-compose up --build -d
```

This will:
- Start MySQL 8 container on port 3306
- Start backend API on port 8080
- Start phpMyAdmin on port 8081 (optional, for database inspection)

### 2.5 Wait for Services to be Ready

Wait about 30 seconds for MySQL to initialize, then verify:

```bash
curl http://localhost:8080/health
```

You should see: `{"status":"ok","timestamp":"..."}`

### 2.6 Run Database Migrations

```bash
cd backend  # Back to backend directory
npm run migrate
```

This creates all database tables.

### 2.7 Seed Database

Populate with test data:

```bash
npm run seed
```

This creates:
- 2 test users
- 15 sample books
- Sample reviews
- Achievement badges

### 2.8 Verify Backend

Test the API:

```bash
# Health check
curl http://localhost:8080/health

# Login (should return JWT tokens)
curl -X POST http://localhost:8080/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"email":"user@test.com","password":"password123"}'
```

## Step 3: iOS Setup

### 3.1 Open Xcode Project

```bash
open Stacks/Stacks.xcodeproj
```

### 3.2 Import Assets

1. In Xcode, right-click on the project navigator
2. Select "Add Files to Stacks..."
3. Navigate to the `/assets` folder
4. Select all image files
5. Ensure "Copy items if needed" is checked
6. Click "Add"

Verify all badge images are present:
- `bronze-badge.png`
- `silder-badge.png` (silver - note typo in filename)
- `gold-badge.png`
- `plat-badge.png`

### 3.3 Configure API Base URL

For **iOS Simulator**:
1. In Xcode, select the "Stacks" scheme
2. Go to Product → Scheme → Edit Scheme
3. Select "Run" → "Arguments"
4. Under "Environment Variables", add:
   - Name: `API_BASE_URL`
   - Value: `http://localhost:8080`

For **Physical Device**:
1. Find your Mac's IP address:
   ```bash
   ipconfig getifaddr en0
   ```
2. Use that IP instead:
   - Name: `API_BASE_URL`
   - Value: `http://YOUR_MAC_IP:8080`

### 3.4 Configure Info.plist (Camera Permission)

Add camera usage description:

1. Open `Info.plist` (or add to target's Info tab)
2. Add key: `NSCameraUsageDescription`
3. Value: `"We need camera access to scan ISBN barcodes"`

### 3.5 Build and Run

1. Select a simulator (e.g., iPhone 15)
2. Press ⌘R or click Run
3. Wait for build to complete

## Step 4: Test the App

### 4.1 First Launch

1. App should show onboarding screens
2. Tap "Get Started"
3. You'll see login screen

### 4.2 Login

Use test credentials:
- **Email**: `user@test.com`
- **Password**: `password123`

Or create a new account with "Sign Up"

### 4.3 Test Features

- **Library**: Should show 10 seeded books
- **Scan**: Tap camera icon to scan ISBN (or use manual entry)
- **Reviews**: Tap a book → "Add Review"
- **Profile**: View stats and badges
- **Explore**: Browse recommendations

## Troubleshooting

### Backend Issues

**MySQL won't start:**
```bash
# Check Docker logs
docker-compose logs mysql

# Restart services
docker-compose down
docker-compose up -d
```

**Port already in use:**
- Change `SERVER_PORT` in `.env` and `docker-compose.yml`
- Or stop conflicting service on port 8080

**Migrations fail:**
```bash
# Reset database (WARNING: deletes all data)
docker-compose down -v
docker-compose up -d
npm run migrate
npm run seed
```

### iOS Issues

**Build errors:**
- Clean build folder: ⌘⇧K
- Delete DerivedData
- Restart Xcode

**API connection fails:**
- Verify backend is running: `curl http://localhost:8080/health`
- Check `API_BASE_URL` environment variable
- For simulator, ensure `localhost` works
- For device, use Mac's IP address

**Missing assets:**
- Re-import assets from `/assets` folder
- Check Asset Catalog in Xcode

**Camera permission denied:**
- Go to iOS Settings → Stacks → Camera → Enable

### Database Access

Access phpMyAdmin:
- URL: `http://localhost:8081`
- Server: `mysql`
- Username: `root`
- Password: `root_password`

## Next Steps

- Read [DEVELOPMENT.md](DEVELOPMENT.md) for contribution guidelines
- See [API.md](API.md) for API documentation
- Check [README.md](README.md) for project overview

## Common Commands

```bash
# Backend
cd backend
docker-compose up -d          # Start services
docker-compose down            # Stop services
docker-compose logs -f backend # View logs
npm run migrate                # Run migrations
npm run seed                   # Seed database
npm test                       # Run tests

# iOS
# Use Xcode for building and running
```

## Support

If you encounter issues not covered here, please:
1. Check Docker and Xcode logs
2. Verify all prerequisites are installed
3. Open a GitHub issue with error details

