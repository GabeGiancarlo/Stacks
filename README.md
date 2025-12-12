# Stacks - iOS Reading App

A production-ready iOS book tracking application with a MySQL backend, built with SwiftUI and Node.js/TypeScript.

## Team Members

- **Gabriel Giancarlo**
- **Nathan Carnahan**

## Project Overview

Stacks is a comprehensive iOS application that allows users to track their reading progress, manage their personal library, write and share book reviews, discover new books, and earn achievement badges. The application features a modern SwiftUI interface with a robust Node.js/TypeScript backend API.

## Features

- **Authentication**: Secure JWT-based authentication with access and refresh tokens
- **Library Management**: Add books to your personal library via ISBN barcode scanning or manual entry
- **Book Reviews**: Write and manage detailed book reviews with star ratings (1-5 stars)
- **Explore**: Discover recommended books based on your reading history
- **Profile**: Track reading statistics and earn achievement badges (Bronze, Silver, Gold, Platinum)
- **Offline Support**: Core Data persistence with automatic sync when online
- **ISBN Scanner**: Built-in barcode scanner using AVFoundation for quick book addition

## Tech Stack

### Backend
- **Runtime**: Node.js 18+
- **Language**: TypeScript 5.3+
- **Framework**: Express.js 4.18+
- **ORM**: TypeORM 0.3.17
- **Database**: MySQL 8.0
- **Authentication**: JWT (jsonwebtoken 9.0.2) with bcrypt 5.1.1 for password hashing
- **Security**: Helmet.js 7.1.0, CORS 2.8.5, express-rate-limit 7.1.5
- **File Upload**: Multer 1.4.5
- **Validation**: class-validator 0.14.0, class-transformer 0.5.1
- **Containerization**: Docker & Docker Compose

### iOS
- **Language**: Swift
- **Framework**: SwiftUI (iOS 17+)
- **Architecture**: MVVM-C (Model-View-ViewModel-Coordinator)
- **Networking**: URLSession with async/await
- **Persistence**: Core Data for offline data storage
- **Security**: Keychain Services for secure token storage
- **Barcode Scanning**: AVFoundation framework
- **Development**: Xcode 15+

## Prerequisites

Before setting up the project, ensure you have the following installed:

- **Docker Desktop** (latest version) - Required for running MySQL database
- **Node.js 18+** - Required for backend development and running migrations
- **npm** (comes with Node.js) - Package manager for backend dependencies
- **Xcode 15+** - Required for iOS development
- **iOS Simulator** (comes with Xcode) or physical iOS device (iOS 17+)
- **Git** - For cloning the repository

## Installation & Setup

### Step 1: Clone the Repository

```bash
git clone https://github.com/GabeGiancarlo/Stacks
cd Stacks
```

### Step 2: Backend Setup

#### 2.1 Navigate to Backend Directory

```bash
cd backend
```

#### 2.2 Install Dependencies

```bash
npm install
```

This will install all required Node.js packages listed in `package.json`:
- express, typeorm, mysql2, bcrypt, jsonwebtoken
- dotenv, cors, helmet, express-rate-limit, multer
- reflect-metadata, class-validator, class-transformer
- TypeScript and development dependencies

#### 2.3 Configure Environment Variables

Create a `.env` file in the `backend` directory:

```bash
cp .env.example .env
```

If `.env.example` doesn't exist, create `.env` with the following content:

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

**Note**: The default values work with Docker Compose. For local development without Docker, change `DB_HOST` to `localhost`.

#### 2.4 Start Docker Services

From the project root directory:

```bash
cd ..  # Go back to project root
docker-compose up --build -d
```

This command will:
- Build and start MySQL 8.0 container on port 3306
- Build and start the backend API container on port 8080
- Start phpMyAdmin on port 8081 (optional, for database management)

Wait approximately 30 seconds for MySQL to fully initialize.

#### 2.5 Verify Backend Health

```bash
curl http://localhost:8080/health
```

Expected response: `{"status":"ok","timestamp":"..."}`

#### 2.6 Run Database Migrations

```bash
cd backend
npm run migrate
```

This creates all necessary database tables:
- `users` - User accounts
- `books` - Book catalog
- `user_books` - User's personal library with reading status
- `reviews` - Book reviews
- `badges` - Achievement badges
- `user_badges` - User badge assignments

#### 2.7 Seed Database with Test Data

```bash
npm run seed
```

This populates the database with:
- 2 test user accounts
- 15 sample books
- Sample reviews
- Achievement badges

**Test User Credentials:**
- Email: `user@test.com`
- Password: `password123`

### Step 3: iOS Setup

#### 3.1 Open Xcode Project

```bash
open Stacks/Stacks.xcodeproj
```

Or manually open `Stacks/Stacks.xcodeproj` in Xcode.

#### 3.2 Import Assets

1. In Xcode, right-click on the project navigator
2. Select "Add Files to Stacks..."
3. Navigate to the `/assets` folder in the project root
4. Select all image files (or drag and drop the entire assets folder)
5. Ensure "Copy items if needed" is checked
6. Ensure "Create groups" is selected
7. Click "Add"

**Important Assets to Verify:**
- Badge images: `bronze-badge.png`, `silder-badge.png` (silver), `gold-badge.png`, `plat-badge.png`
- Profile images and book covers
- UI elements from the assets folder

#### 3.3 Configure API Base URL

**For iOS Simulator:**
1. In Xcode, select the "Stacks" scheme
2. Go to **Product → Scheme → Edit Scheme...**
3. Select **Run** in the left sidebar
4. Go to the **Arguments** tab
5. Under **Environment Variables**, click the **+** button
6. Add:
   - **Name**: `API_BASE_URL`
   - **Value**: `http://localhost:8080`

**For Physical iOS Device:**
1. Find your Mac's IP address:
   ```bash
   ipconfig getifaddr en0
   # or for Wi-Fi: ipconfig getifaddr en1
   ```
2. Use that IP address instead:
   - **Name**: `API_BASE_URL`
   - **Value**: `http://YOUR_MAC_IP:8080` (e.g., `http://192.168.1.100:8080`)

**Important**: The device and Mac must be on the same Wi-Fi network.

#### 3.4 Configure Camera Permission (Required for ISBN Scanner)

1. Open `Stacks/Stacks/Info.plist` in Xcode
2. Add the following key-value pair:
   - **Key**: `NSCameraUsageDescription`
   - **Type**: String
   - **Value**: `We need camera access to scan ISBN barcodes`

Alternatively, you can add this in Xcode:
1. Select the project in the navigator
2. Select the "Stacks" target
3. Go to the **Info** tab
4. Add "Privacy - Camera Usage Description" with value: `We need camera access to scan ISBN barcodes`

#### 3.5 Build and Run

1. Select a target device:
   - iOS Simulator (recommended for first run): iPhone 15 or later
   - Physical device: Connect via USB and select it
2. Press **⌘R** or click the **Run** button
3. Wait for the build to complete (first build may take several minutes)

## Running the Application

### Starting the Backend

If Docker services are not running:

```bash
# From project root
docker-compose up -d
```

Check backend status:
```bash
curl http://localhost:8080/health
```

### Starting the iOS App

1. Open Xcode
2. Open `Stacks/Stacks.xcodeproj`
3. Select your target device (Simulator or physical device)
4. Press **⌘R** to build and run

### First Launch

1. The app will show onboarding screens on first launch
2. Tap "Get Started" to proceed
3. You'll see the login screen

### Login

Use the test credentials:
- **Email**: `user@test.com`
- **Password**: `password123`

Or create a new account using the "Sign Up" option.

## Application Navigation & Usage

### Main Features

1. **Home/Library Tab**: 
   - View all books in your personal library
   - Books are displayed in a grid layout
   - Tap a book to view details and reviews
   - Swipe to delete books from your library

2. **Scanner Tab**:
   - Tap the camera icon to scan ISBN barcodes
   - Grant camera permission when prompted
   - Alternatively, use "Manual Entry" to add books without scanning
   - Fill in book details (title, author, ISBN, description, year)
   - Optionally upload a cover image

3. **Explore Tab**:
   - Browse recommended books
   - Discover new titles based on your reading history
   - Tap books to view details

4. **Profile Tab**:
   - View your reading statistics:
     - Total books in library
     - Books read
     - Reviews written
     - Reading streak
   - View earned achievement badges
   - Logout option

### Important Navigation Notes

- **Sidebar Menu**: Accessible via hamburger menu button (top-left) on most screens
- **Book Status**: When viewing a book, you can change its status:
  - Want to Read
  - Currently Reading
  - Read
- **Adding Reviews**: 
  - Navigate to a book's detail page
  - Tap "Add Review" or "Edit Review"
  - Select star rating (1-5 stars)
  - Write review text
  - Save review
- **Username Format**: Usernames are case-sensitive and must be unique
- **Email Format**: Standard email format required (e.g., `user@example.com`)

## Database

### Database Information

- **Database Name**: `stacks_db`
- **Host**: `localhost` (or `mysql` when using Docker)
- **Port**: `3306`
- **Username**: `stacks_user`
- **Password**: `secure_password`
- **Root Password**: `root_password`

### Accessing the Database

**Via phpMyAdmin:**
- URL: `http://localhost:8081`
- Server: `mysql`
- Username: `root`
- Password: `root_password`

**Via MySQL Command Line:**
```bash
docker exec -it stacks_mysql mysql -u stacks_user -p
# Password: secure_password
```

**Via MySQL Client:**
```bash
mysql -h localhost -P 3306 -u stacks_user -p
# Password: secure_password
```

### Database Schema

The database consists of 6 main tables:

1. **users**: User accounts with email, password hash, and username
2. **books**: Book catalog with ISBN, title, author, cover, description, and publication year
3. **user_books**: Junction table linking users to books with reading status (want_to_read, reading, read)
4. **reviews**: Book reviews with ratings (1-5) and review text
5. **badges**: Achievement badge definitions with tier (bronze, silver, gold, platinum)
6. **user_badges**: User badge assignments with earned date

See `backend/src/migrations/1700000000000-InitialSchema.ts` for complete schema definition.

### Creating a Database Dump

A SQL dump script is provided. See the **Database Dump** section below.

## Installed Libraries & Dependencies

### Backend Dependencies (package.json)

**Production Dependencies:**
- `express` ^4.18.2 - Web framework
- `typeorm` ^0.3.17 - ORM for database operations
- `mysql2` ^3.6.5 - MySQL driver
- `bcrypt` ^5.1.1 - Password hashing
- `jsonwebtoken` ^9.0.2 - JWT token generation/verification
- `dotenv` ^16.3.1 - Environment variable management
- `cors` ^2.8.5 - Cross-origin resource sharing
- `helmet` ^7.1.0 - Security headers
- `express-rate-limit` ^7.1.5 - Rate limiting
- `multer` ^1.4.5-lts.1 - File upload handling
- `reflect-metadata` ^0.1.13 - Metadata reflection for decorators
- `class-validator` ^0.14.0 - Validation decorators
- `class-transformer` ^0.5.1 - Object transformation

**Development Dependencies:**
- `typescript` ^5.3.3 - TypeScript compiler
- `ts-node` ^10.9.2 - TypeScript execution
- `ts-node-dev` ^2.0.0 - Development server with hot reload
- `@types/express` ^4.17.21 - TypeScript types for Express
- `@types/node` ^20.10.6 - TypeScript types for Node.js
- `@types/bcrypt` ^5.0.2 - TypeScript types for bcrypt
- `@types/jsonwebtoken` ^9.0.5 - TypeScript types for JWT
- `@types/cors` ^2.8.17 - TypeScript types for CORS
- `@types/multer` ^1.4.11 - TypeScript types for Multer
- `@types/jest` ^29.5.11 - TypeScript types for Jest
- `jest` ^29.7.0 - Testing framework
- `ts-jest` ^29.1.1 - Jest TypeScript preprocessor
- `eslint` ^8.56.0 - Linting tool
- `@typescript-eslint/eslint-plugin` ^6.17.0 - ESLint plugin for TypeScript
- `@typescript-eslint/parser` ^6.17.0 - ESLint parser for TypeScript

### iOS Dependencies

The iOS app uses native iOS frameworks (no external package managers like CocoaPods or SPM):

- **SwiftUI** - UI framework (iOS 17+)
- **Foundation** - Core functionality
- **Core Data** - Data persistence
- **AVFoundation** - Barcode scanning
- **Security/Keychain** - Secure token storage
- **Combine** - Reactive programming (for ViewModels)

## Resources Used

### Documentation & Learning Resources

- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [Express.js Documentation](https://expressjs.com/)
- [TypeORM Documentation](https://typeorm.io/)
- [MySQL Documentation](https://dev.mysql.com/doc/)
- [JWT.io](https://jwt.io/) - JWT token debugging and information
- [Docker Documentation](https://docs.docker.com/)

### APIs & Services

- **OpenLibrary API** (potential future integration for ISBN lookup)
- **Google Books API** (potential future integration for book metadata)

### Design Resources

- Custom UI mockups (see `/Intitled-mockup-v1/` folder)
- Asset images provided in `/assets/` folder

## Project Structure

```
Stacks/
├── backend/                    # Node.js/TypeScript API
│   ├── src/
│   │   ├── entities/          # TypeORM entities (User, Book, Review, Badge, etc.)
│   │   ├── routes/            # Express route handlers (auth, books, reviews, etc.)
│   │   ├── middleware/        # Auth middleware, error handlers
│   │   ├── utils/             # Utility functions (JWT, auth helpers)
│   │   ├── migrations/        # Database migrations
│   │   ├── scripts/           # Seed scripts
│   │   └── index.ts           # Server entry point
│   ├── uploads/               # Uploaded book cover images
│   ├── Dockerfile             # Docker image configuration
│   ├── package.json           # Node.js dependencies
│   └── tsconfig.json          # TypeScript configuration
│
├── Stacks/                    # iOS SwiftUI app
│   ├── App/                   # App entry point & coordinator
│   ├── Core/
│   │   ├── Networking/        # APIClient, Endpoints, NetworkError
│   │   └── Persistence/       # CoreDataStack, KeychainManager
│   ├── Features/              # Feature modules
│   │   ├── Authentication/    # Login, SignUp views
│   │   ├── Home/              # Home/Library view
│   │   ├── Library/           # Library management
│   │   ├── Scanner/           # ISBN barcode scanner
│   │   ├── Reviews/           # Review creation/editing
│   │   ├── Explore/          # Book recommendations
│   │   ├── Profile/           # User profile and stats
│   │   ├── Onboarding/        # Onboarding flow
│   │   └── Notifications/     # Notifications (if implemented)
│   ├── Models/                # Data models (User, Book, Review, Badge)
│   ├── Services/              # Business logic services
│   │   ├── AuthService.swift
│   │   ├── LibraryService.swift
│   │   ├── ProfileService.swift
│   │   └── ReviewService.swift
│   ├── DesignSystem/          # UI components and design tokens
│   │   ├── Colors.swift
│   │   ├── Typography.swift
│   │   └── Components/        # Reusable UI components
│   └── StacksModel.xcdatamodeld/  # Core Data model
│
├── assets/                     # Image assets (badges, book covers, profile images)
├── docker-compose.yml          # Docker Compose configuration
├── README.md                   # This file
├── SETUP.md                    # Detailed setup instructions
├── DEVELOPMENT.md              # Development guidelines
├── API.md                      # API endpoint documentation
└── XCODE_SETUP_GUIDE.md       # Xcode-specific setup guide
```

## API Endpoints

See [API.md](API.md) for complete API documentation.

**Base URL**: `http://localhost:8080` (development)

**Key Endpoints:**
- `POST /api/auth/signup` - Create new user account
- `POST /api/auth/login` - Authenticate user
- `POST /api/auth/refresh` - Refresh access token
- `GET /api/books` - Get user's library
- `POST /api/books` - Add book to library
- `GET /api/books/:id` - Get book details with reviews
- `POST /api/books/:bookId/reviews` - Create review
- `GET /api/explore/recommendations` - Get book recommendations
- `GET /api/users/me` - Get current user profile
- `GET /api/users/me/badges` - Get user's badges

## Testing

### Backend Tests

```bash
cd backend
npm test
```

Tests are located in `backend/src/__tests__/`

### iOS Tests

Run tests in Xcode:
1. Press **⌘U** or go to **Product → Test**
2. Or use command line:
   ```bash
   xcodebuild test -scheme Stacks -destination 'platform=iOS Simulator,name=iPhone 15'
   ```

## Troubleshooting

### Backend Issues

**MySQL container won't start:**
```bash
# Check Docker logs
docker-compose logs mysql

# Restart services
docker-compose down
docker-compose up -d
```

**Port 8080 already in use:**
- Stop the conflicting service, or
- Change `SERVER_PORT` in `.env` and `docker-compose.yml`

**Migrations fail:**
```bash
# Reset database (WARNING: deletes all data)
docker-compose down -v
docker-compose up -d
cd backend
npm run migrate
npm run seed
```

**Backend not responding:**
```bash
# Check if containers are running
docker-compose ps

# View backend logs
docker-compose logs -f backend

# Restart backend
docker-compose restart backend
```

### iOS Issues

**Build errors:**
- Clean build folder: **⌘⇧K** in Xcode
- Delete DerivedData: `rm -rf ~/Library/Developer/Xcode/DerivedData`
- Restart Xcode

**API connection fails:**
- Verify backend is running: `curl http://localhost:8080/health`
- Check `API_BASE_URL` environment variable in Xcode scheme
- For simulator: ensure `localhost` is used
- For device: ensure Mac's IP address is correct and both devices are on same network
- Check firewall settings on Mac

**Missing assets:**
- Re-import assets from `/assets` folder
- Verify Asset Catalog in Xcode project navigator

**Camera permission denied:**
- Go to iOS Settings → Stacks → Camera → Enable
- Or delete app and reinstall

**App crashes on launch:**
- Check Xcode console for error messages
- Verify Core Data model is properly configured
- Ensure all required assets are included

## Database Dump

A SQL dump of the database is included in the submission. To create a fresh dump:

```bash
# Ensure Docker services are running
docker-compose up -d

# Run the dump script (from project root)
./create_dump.sh
```

Or manually:
```bash
docker exec stacks_mysql mysqldump -u stacks_user -psecure_password stacks_db > database_dump.sql
```

The dump file `database_dump.sql` contains:
- Complete database schema (CREATE TABLE statements)
- All data (INSERT statements)
- Foreign key constraints
- Indexes

To restore the database:
```bash
docker exec -i stacks_mysql mysql -u stacks_user -psecure_password stacks_db < database_dump.sql
```

## Development Workflow

See [DEVELOPMENT.md](DEVELOPMENT.md) for:
- Architecture decisions
- Code style guidelines
- Git workflow
- Adding new features
- Testing practices

## Deployment

### Backend Deployment

1. Build Docker image:
   ```bash
   cd backend
   docker build -t stacks-backend .
   ```

2. Push to container registry (Docker Hub, AWS ECR, etc.)

3. Update `docker-compose.yml` with production environment variables

4. Deploy to cloud platform (AWS ECS, Google Cloud Run, Heroku, etc.)

### iOS Deployment

1. Configure release scheme with production API URL
2. Archive in Xcode: **Product → Archive**
3. Upload to App Store Connect
4. Submit for App Store review

## License

MIT

## Support

For issues and questions:
- Check the troubleshooting section above
- Review [SETUP.md](SETUP.md) for detailed setup instructions
- Review [API.md](API.md) for API documentation
- Open a GitHub issue with error details and logs

## Acknowledgments

- Built with SwiftUI and Express.js
- Database powered by MySQL 8
- Containerized with Docker

---

**Last Updated**: December 2024
**Version**: 1.0.0
