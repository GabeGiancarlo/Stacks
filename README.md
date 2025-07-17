# Intitled

A modern iOS app for managing your personal library with seamless scanning, social discovery, and beautiful shelf customization.

## Features

- 📚 **Smart Library Management** - Organize books into custom shelves
- 📱 **ISBN Scanning** - Instant book recognition via camera
- 🌟 **Social Discovery** - Connect with friends and discover trending reads
- 🎨 **Custom Shelf Themes** - Personalize your library appearance
- 🏆 **Achievement Badges** - Unlock rewards for reading milestones
- ☁️ **CloudKit Sync** - Access your library across all devices

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                      IntitledApp                             │
│  ┌─────────────────┐  Main app entry & navigation           │
│  │   RootTabView   │  ← 5-tab interface (Library, Scanner,  │
│  │   AppModel      │    Discover, Profile, Shop)            │
│  └─────────────────┘                                        │
├─────────────────────────────────────────────────────────────┤
│                   Feature Modules                           │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Library   │ │   Scanner   │ │  Discover   │           │
│  │   Feature   │ │   Feature   │ │   Feature   │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
│  ┌─────────────┐ ┌─────────────┐                           │
│  │   Profile   │ │    Shop     │                           │
│  │   Feature   │ │   Feature   │                           │
│  └─────────────┘ └─────────────┘                           │
├─────────────────────────────────────────────────────────────┤
│                   Services Layer                            │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │    Books    │ │    Image    │ │    Shelf    │           │
│  │ API Gateway │ │   Loader    │ │ Style Store │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
├─────────────────────────────────────────────────────────────┤
│                    Data Layer                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Models    │ │ Core Data + │ │   Book      │           │
│  │  (MVVM-C)   │ │  CloudKit   │ │ Repository  │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
├─────────────────────────────────────────────────────────────┤
│                    Resources                                │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Assets    │ │    Color    │ │    Shelf    │           │
│  │ & Images    │ │   Tokens    │ │   Themes    │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

## Requirements

- **macOS:** 12.0+ (for development)
- **iOS:** 16.0+ (target deployment)
- **Xcode:** 15.0+ (required for iOS development)
- **Swift:** 5.9+

## Setup & Installation

### Option 1: Native iOS Development (Recommended)

1. **Install Xcode** from the Mac App Store (required for iOS development)

2. **Clone and Setup:**
   ```bash
   git clone https://github.com/yourusername/Intitled.git
   cd Intitled
   
   # Open in Xcode (this will generate the Xcode project)
   open Package.swift
   ```

3. **Configure Signing:**
   - Select your development team in Xcode
   - Update the bundle identifier if needed

4. **Run the Project:**
   - Select an iOS simulator or device
   - Press ⌘+R to build and run

### Option 2: Swift Package Manager (Library Development)

```bash
# For library/framework development
swift build

# Run tests
swift test

# Generate Xcode project for SPM
swift package generate-xcodeproj
```

**Note:** Full iOS app development requires Xcode. SPM alone is insufficient for iOS apps with camera permissions, CloudKit integration, and StoreKit features.

## Project Structure

```
Intitled/
├── Package.swift                 # Swift Package Manager manifest
├── Sources/
│   ├── IntitledApp/             # Main app entry point
│   │   ├── IntitledApp.swift    # @main app struct
│   │   ├── AppModel.swift       # App-wide state management
│   │   └── RootTabView.swift    # 5-tab navigation
│   ├── LibraryFeature/          # Library management module
│   │   ├── LibraryView.swift    # Main library interface
│   │   ├── ShelfDetailView.swift# Individual shelf display
│   │   └── BookSpineView.swift  # Book component
│   ├── ScannerFeature/          # ISBN scanning module
│   │   ├── ScannerView.swift    # Camera scanner interface
│   │   └── ScanResultSheet.swift# Scan result presentation
│   ├── DiscoverFeature/         # Social discovery module
│   │   └── DiscoverView.swift   # Friends/Trending/Search
│   ├── ProfileFeature/          # User profile module
│   │   └── ProfileView.swift    # Profile & badges
│   ├── ShopFeature/             # In-app purchases module
│   │   └── ShopView.swift       # Shelf theme store
│   ├── DataLayer/               # Core Data & models
│   │   ├── Models/              # Domain models
│   │   ├── PersistenceController.swift # Core Data + CloudKit
│   │   └── BookRepository.swift # Data access layer
│   ├── ServicesLayer/           # External services
│   │   ├── BooksAPIGateway.swift# Open Library + Google Books
│   │   ├── ImageLoader.swift    # Async image caching
│   │   └── ShelfStyleStore.swift# StoreKit 2 integration
│   └── Resources/               # Assets & resources
│       ├── Assets/              # Images, colors, themes
│       └── ResourceManager.swift# Asset management
├── Tests/
│   └── IntitledTests/           # Unit & integration tests
└── .github/workflows/           # CI/CD pipeline
```

## API Integration

### Books Metadata
- **Primary:** [Open Library API](https://openlibrary.org/developers/api)
- **Fallback:** [Google Books API](https://developers.google.com/books/docs/v1/using)

### Cloud Services
- **Sync:** CloudKit (Apple's native cloud database)
- **Auth:** FirebaseAuth (for social features, future)

## Development Roadmap

| Sprint | Focus Area | Features | Status |
|--------|------------|----------|--------|
| **0** | **Project Bootstrap** | Project setup, basic structure, CI/CD | ✅ **Complete** |
| **1** | **Core Scanning & Library** | ISBN scanning, book metadata, basic shelves | 🔄 **Next** |
| **2** | **Social Features** | Friend connections, reading discovery | 📋 **Planned** |
| **3** | **Shop & Customization** | Shelf themes, in-app purchases, badges | 📋 **Planned** |
| **4** | **Polish & Performance** | Animations, optimization, accessibility | 📋 **Planned** |
| **5** | **Launch Preparation** | App Store assets, marketing, final testing | 📋 **Planned** |

## Testing Strategy

```bash
# Run all tests
swift test

# Run with coverage
swift test --enable-code-coverage

# iOS-specific testing (requires Xcode)
xcodebuild test -scheme IntitledApp -destination 'platform=iOS Simulator,name=iPhone 15'
```

### Test Coverage Goals
- **Unit Tests:** ≥80% coverage for business logic
- **Integration Tests:** API gateways, data repositories
- **UI Tests:** Critical user flows (scanning, adding books)

## Contributing

### Code Style
- **SwiftLint:** Enforced via CI pipeline
- **MVVM-C:** Architecture pattern for features
- **Async/Await:** Preferred over completion handlers
- **File Structure:** One public type per file, <300 LOC preferred

### Development Workflow
1. **Fork** the repository
2. **Create** a feature branch (`git checkout -b feature/amazing-feature`)
3. **Follow** the coding style and run tests
4. **Commit** with conventional commit messages
5. **Push** and create a Pull Request

### Commit Convention
```
feat(scope): add amazing new feature
fix(scanner): resolve camera permission issue
docs(readme): update installation instructions
test(library): add shelf creation tests
chore(ci): update GitHub Actions workflow
```

## Troubleshooting

### Common Issues

**"xcodebuild: command not found"**
- Install Xcode from the Mac App Store
- Run `sudo xcode-select --install` for command line tools

**"Package.swift compilation failed"**
- Ensure you have Swift 5.9+ installed
- Open Package.swift in Xcode instead of command line

**"iOS Simulator not found"**
- Open Xcode and download iOS simulators
- Devices & Simulators → iOS → Download runtime

### Performance Tips
- **Image Caching:** Automatic via `ImageLoader`
- **Core Data:** Batch operations for large imports
- **Memory:** Use `LazyVStack` for large book collections

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

**Built with ❤️ using SwiftUI, Core Data + CloudKit, and the power of books 📚** 