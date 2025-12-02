# Stacks - iOS Reading App

A production-ready iOS book tracking application with a MySQL backend, built with SwiftUI and Node.js/TypeScript.

## Features

- **Authentication**: Secure JWT-based auth with refresh tokens
- **Library Management**: Add books via ISBN scan or manual entry
- **Reviews**: Write and manage book reviews with star ratings
- **Explore**: Discover recommended books
- **Profile**: Track reading stats and earn achievement badges
- **Offline Support**: Core Data persistence with sync

## Tech Stack

### Backend
- Node.js + TypeScript + Express
- TypeORM with MySQL 8
- JWT authentication (access + refresh tokens)
- Docker Compose for local development

### iOS
- SwiftUI (iOS 17+)
- MVVM-C architecture
- Core Data for offline persistence
- AVFoundation for barcode scanning

## Quick Start

### Prerequisites

- Docker Desktop
- Node.js 18+ (for local development)
- Xcode 15+
- iOS Simulator or device

### Backend Setup

1. Clone the repository:
```bash
git clone https://github.com/GabeGiancarlo/Stacks
cd Stacks
```

2. Navigate to backend directory:
```bash
cd backend
```

3. Copy environment file:
```bash
cp .env.example .env
```

4. Edit `.env` with your local settings (defaults work for Docker)

5. Start services:
```bash
docker-compose up --build -d
```

6. Run migrations:
```bash
npm install
npm run migrate
```

7. Seed database:
```bash
npm run seed
```

8. Verify health:
```bash
curl http://localhost:8080/health
```

### iOS Setup

1. Open `Stacks/Stacks.xcodeproj` in Xcode

2. Configure API URL:
   - Edit scheme → Run → Arguments → Environment Variables
   - Add: `API_BASE_URL` = `http://localhost:8080` (for simulator)
   - For physical device, use your Mac's IP address

3. Import assets:
   - Drag all files from `/assets` folder into Xcode Asset Catalog
   - Ensure all badge images are included

4. Build and run (⌘R)

5. Test login:
   - Email: `user@test.com`
   - Password: `password123`

## Project Structure

```
Stacks/
├── backend/              # Node.js/TypeScript API
│   ├── src/
│   │   ├── entities/    # TypeORM entities
│   │   ├── routes/       # API routes
│   │   ├── middleware/   # Auth middleware
│   │   ├── migrations/   # Database migrations
│   │   └── scripts/      # Seeding scripts
│   ├── docker-compose.yml
│   └── Dockerfile
│
├── Stacks/               # iOS SwiftUI app
│   ├── App/              # App entry & coordinator
│   ├── Core/             # Networking, persistence
│   ├── Features/         # Feature modules
│   ├── Models/           # Data models
│   ├── Services/         # Business logic services
│   └── DesignSystem/     # UI components
│
└── assets/               # Image assets
```

## API Endpoints

See [API.md](API.md) for complete API documentation.

## Development

See [DEVELOPMENT.md](DEVELOPMENT.md) for contribution guidelines and development workflow.

## Testing

### Backend Tests
```bash
cd backend
npm test
```

### iOS Tests
```bash
xcodebuild test -scheme Stacks -destination 'platform=iOS Simulator,name=iPhone 15'
```

## Deployment

### Backend
- Docker image can be deployed to any container registry
- Update `docker-compose.yml` for production environment variables
- Configure MySQL with persistent volumes

### iOS
- Configure release scheme with production API URL
- Archive and upload to App Store Connect

## License

MIT

## Contributing

1. Create feature branch: `feat/your-feature`
2. Make changes following code style guidelines
3. Write tests
4. Submit pull request

## Support

For issues and questions, please open a GitHub issue.

