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
┌─────────────────┐
│   IntitledApp   │  ← Main app entry & navigation
├─────────────────┤
│ Feature Modules │  ← Library, Scanner, Discover, Profile, Shop
├─────────────────┤
│ Services Layer  │  ← API gateway, image loading, purchases
├─────────────────┤
│   Data Layer    │  ← Core Data + CloudKit persistence
├─────────────────┤
│   Resources     │  ← Assets, themes, localization
└─────────────────┘
```

## Requirements

- iOS 16.0+
- Xcode 15.0+
- Swift 5.9+

## Build & Run

```bash
# Clone the repository
git clone https://github.com/yourusername/Intitled.git
cd Intitled

# Build the project
swift build

# Run tests
xcodebuild test -scheme IntitledApp

# Open in Xcode
open Package.swift
```

## Project Roadmap

| Sprint | Focus | Status |
|--------|-------|--------|
| 0 | Project Bootstrap | ✅ In Progress |
| 1 | Core Scanning & Library | 🔄 Planned |
| 2 | Social Features | 📋 Planned |
| 3 | Shop & Customization | 📋 Planned |
| 4 | Polish & Performance | 📋 Planned |
| 5 | Launch Preparation | 📋 Planned |

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details. 