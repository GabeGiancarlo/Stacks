# Stacks iOS App - Setup Instructions

## Project Structure

The SwiftUI iOS app has been created with the following structure:

```
Stacks/
├── Models/              # Data models (User, Book, Shelf, Review, etc.)
├── Views/              # SwiftUI views organized by feature
│   ├── Authentication/ # Login, Sign Up, Onboarding
│   ├── Home/           # Home screen and sidebar
│   ├── Explore/        # Book discovery
│   ├── Scan/           # Book scanning
│   ├── Library/        # User's library
│   ├── BookDetail/     # Book detail page
│   ├── Review/         # Review views
│   └── Profile/        # User profile
├── ViewModels/         # MVVM view models
├── Services/           # API service interfaces and mock implementations
├── DesignSystem/      # Theme, colors, typography, components
├── StacksApp.swift    # App entry point
└── ContentView.swift  # Root view
```

## Setup Steps

### 1. Open Project in Xcode

1. Open `Stacks.xcodeproj` in Xcode 15.0 or later
2. Xcode may prompt you to add files to the project - **accept all**

### 2. Add All Swift Files to Project

If files are not automatically detected, manually add them:

1. Right-click on the `Stacks` folder in the Project Navigator
2. Select "Add Files to Stacks..."
3. Navigate to the `Stacks` directory
4. Select all Swift files (or the entire directory structure)
5. Ensure "Copy items if needed" is **unchecked**
6. Ensure "Create groups" is selected
7. Click "Add"

### 3. Verify Build Settings

1. Select the project in the Project Navigator
2. Select the "Stacks" target
3. Go to "Build Settings"
4. Verify:
   - **iOS Deployment Target**: 17.0
   - **Swift Language Version**: Swift 5.9
   - **Product Bundle Identifier**: com.stacks.app

### 4. Build and Run

1. Select a simulator (iPhone 15 Pro recommended)
2. Press `Cmd + R` to build and run
3. The app should launch with the onboarding screen

## Features Implemented

✅ **Authentication Flow**
- Onboarding screen
- Login screen
- Sign Up screen
- Authentication state management

✅ **Main Navigation**
- Tab-based navigation (Home, Explore, Scan, Library, Profile)
- Sidebar navigation

✅ **Home Screen**
- Welcome message
- Reading statistics
- Currently reading section
- Recent activity feed

✅ **Library Management**
- Book collection view
- Filter by reading status
- Book grid layout

✅ **Book Details**
- Book information display
- Add to library functionality
- Reviews section

✅ **Review System**
- Write reviews
- View reviews
- Rating system

✅ **Explore/Discover**
- Search functionality
- Featured books
- Genre browsing

✅ **Scan Feature**
- Camera interface (placeholder)
- Manual ISBN entry
- Book lookup

✅ **Profile**
- User information
- Reading statistics
- Badges display
- Reading goals
- Settings

## Mock Data

All services use mock implementations with simulated network delays:
- `MockAuthService` - Authentication
- `MockBookService` - Book operations
- `MockShelfService` - Shelf management
- `MockReviewService` - Review operations

## Design System

The app uses a dark-mode-first design system:
- **Colors**: Defined in `AppTheme.Colors`
- **Typography**: Defined in `AppTheme.Typography`
- **Spacing**: Defined in `AppTheme.Spacing`
- **Components**: Reusable button styles, cards, etc.

## Next Steps

1. **Connect to Backend API**: Replace mock services with real API calls
2. **Add Camera Integration**: Implement VisionKit for book scanning
3. **Add Persistence**: Implement Core Data for offline support
4. **Add Images**: Add actual book cover images and app icons
5. **Testing**: Add unit tests and UI tests

## Troubleshooting

### Files Not Found
If you see "Cannot find type" errors:
1. Ensure all Swift files are added to the Xcode project
2. Check that files are in the correct target membership
3. Clean build folder (Cmd + Shift + K) and rebuild

### Build Errors
1. Verify iOS Deployment Target is 17.0
2. Ensure Swift version is 5.9
3. Check that all dependencies are resolved

### Runtime Issues
1. Check console for error messages
2. Verify mock data is being generated correctly
3. Ensure authentication flow is working

## Notes

- The project uses Swift Concurrency (async/await) throughout
- All ViewModels are marked with `@MainActor` for thread safety
- The app follows MVVM architecture pattern
- Services are protocol-based for easy testing and swapping

