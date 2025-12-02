# Development Guide

This document outlines development practices, architecture decisions, and contribution guidelines for the Stacks project.

## Architecture

### Backend

- **Framework**: Express.js with TypeScript
- **ORM**: TypeORM
- **Database**: MySQL 8
- **Auth**: JWT (access + refresh tokens)
- **Validation**: class-validator (can be added)

### iOS

- **Framework**: SwiftUI (iOS 17+)
- **Architecture**: MVVM-C (Model-View-ViewModel-Coordinator)
- **Networking**: URLSession with async/await
- **Persistence**: Core Data (for offline support)
- **Storage**: Keychain for tokens

## Project Structure

### Backend

```
backend/
├── src/
│   ├── entities/          # TypeORM entities (User, Book, etc.)
│   ├── routes/            # Express route handlers
│   ├── middleware/        # Auth middleware, error handlers
│   ├── utils/             # Utility functions (auth, etc.)
│   ├── migrations/        # Database migrations
│   ├── scripts/           # Seed scripts
│   └── index.ts           # Server entry point
├── docker-compose.yml
└── Dockerfile
```

### iOS

```
Stacks/
├── App/                   # App entry, coordinator
├── Core/
│   ├── Networking/        # APIClient, endpoints
│   └── Persistence/       # Core Data, Keychain
├── Features/              # Feature modules
│   ├── Authentication/
│   ├── Library/
│   ├── Scanner/
│   ├── Reviews/
│   ├── Explore/
│   └── Profile/
├── Models/                # Data models
├── Services/              # Business logic services
└── DesignSystem/         # UI components, colors, typography
```

## Adding New Features

### Backend: Adding a New Endpoint

1. **Create route handler** in `src/routes/`:

```typescript
// src/routes/example.ts
import { Router } from 'express';
import { authenticateToken } from '../middleware/auth';

const router = Router();
router.use(authenticateToken);

router.get('/example', async (req, res) => {
  // Handler logic
});

export default router;
```

2. **Register route** in `src/index.ts`:

```typescript
import exampleRoutes from './routes/example';
app.use('/api/example', exampleRoutes);
```

3. **Add tests** in `src/__tests__/`

4. **Update API.md** with endpoint documentation

### iOS: Adding a New View

1. **Create view** in appropriate feature folder:

```swift
// Features/Example/ExampleView.swift
struct ExampleView: View {
    var body: some View {
        Text("Example")
    }
}
```

2. **Create ViewModel** if needed:

```swift
// Features/Example/ExampleViewModel.swift
@MainActor
class ExampleViewModel: ObservableObject {
    // View state
}
```

3. **Add navigation** in coordinator or parent view

4. **Add tests** in `Tests/`

## Database Changes

### Creating a Migration

1. **Generate migration**:

```bash
npm run migrate:generate src/migrations/AddNewColumn
```

2. **Edit migration file** to add/remove columns

3. **Run migration**:

```bash
npm run migrate
```

4. **Update entity** in `src/entities/`

5. **Update seed script** if needed

## Code Style

### TypeScript/Backend

- Use TypeScript strict mode
- Prefer `async/await` over callbacks
- Use descriptive variable names
- Max function length: 50 lines
- Add JSDoc comments for public functions

**Linting:**
```bash
npm run lint
npm run lint:fix
```

### Swift/iOS

- Follow Swift API Design Guidelines
- Use `async/await` for async operations
- Prefer `@Published` for ObservableObject properties
- Use `@MainActor` for UI-related code
- Max function length: 50 lines

**Linting:**
- Use SwiftLint (configure in Xcode)
- No force unwraps without guard clauses

## Testing

### Backend Tests

**Location**: `src/__tests__/`

**Run tests:**
```bash
npm test
npm run test:watch
```

**Coverage target**: 80% on critical paths

### iOS Tests

**Unit Tests**: `Tests/UnitTests/`
**UI Tests**: `Tests/UITests/`

**Run tests:**
```bash
xcodebuild test -scheme Stacks
```

**Coverage target**: 70% on ViewModels

## Git Workflow

### Branch Naming

- `feat/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `refactor/component-name` - Refactoring
- `test/test-description` - Adding tests
- `docs/documentation-update` - Documentation

### Commit Messages

Use conventional commits:

```
feat: add ISBN scanning feature
fix: resolve token refresh issue
test: add integration tests for auth
docs: update API documentation
refactor: simplify APIClient
```

### Pull Request Process

1. Create feature branch from `main`
2. Make changes with tests
3. Ensure all tests pass
4. Update documentation if needed
5. Create PR with description
6. Request review
7. Merge after approval

## Environment Variables

### Backend

Required variables (see `.env.example`):

- `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, `DB_NAME`
- `JWT_SECRET`, `JWT_REFRESH_SECRET`
- `SERVER_PORT`
- `CORS_ORIGIN`

### iOS

- `API_BASE_URL` - Set in Xcode scheme environment variables

## Debugging

### Backend

**View logs:**
```bash
docker-compose logs -f backend
```

**Database access:**
- phpMyAdmin: `http://localhost:8081`
- Direct MySQL: `docker exec -it stacks_mysql mysql -u stacks_user -p`

### iOS

**View network requests:**
- Enable logging in `APIClient.swift` (DEBUG builds)
- Use Network Link Conditioner for testing offline scenarios

**Core Data debugging:**
- Enable SQL debugging in scheme: `-com.apple.CoreData.SQLDebug 1`

## Performance

### Backend

- Database queries should use indexes
- Use connection pooling (TypeORM handles this)
- Implement pagination for large datasets
- Cache frequently accessed data (future: Redis)

### iOS

- Use `LazyVGrid` for large lists
- Load images asynchronously
- Cache API responses in Core Data
- Minimize main thread work

## Security

### Backend

- Never log passwords or tokens
- Use parameterized queries (TypeORM handles this)
- Validate all input
- Rate limit auth endpoints
- Use HTTPS in production

### iOS

- Store tokens in Keychain (not UserDefaults)
- Validate API responses
- Don't store sensitive data in Core Data
- Use secure network transport (HTTPS)

## Known Issues & TODOs

### Current Limitations

1. **ISBN Lookup**: Scanner creates placeholder books. Should integrate OpenLibrary/Google Books API
2. **Image Upload**: Cover images stored locally. Should use cloud storage (S3, Cloudinary)
3. **Offline Sync**: Core Data sync is basic. Needs conflict resolution
4. **Badge System**: Badge earning logic not implemented. Needs background job

### Future Enhancements

- [ ] Email verification
- [ ] Password reset flow
- [ ] Social login (OAuth)
- [ ] Book recommendations algorithm
- [ ] Reading goals and challenges
- [ ] Export reading data
- [ ] Dark mode support (design system ready)

## Questions?

- Check existing code for patterns
- Review API.md for endpoint details
- Open a GitHub issue for clarification

