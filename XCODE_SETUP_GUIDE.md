# Xcode Setup Guide - Step by Step

## Step 1: Create New Project

1. Open Xcode
2. File → New → Project
3. Select **iOS** → **App**
4. Click **Next**

### Project Options Dialog:
- **Product Name**: `Stacks` ✅
- **Team**: Select your team (or "None" for local dev)
- **Organization Identifier**: `Vulcan` (or your preference like `com.yourname`)
- **Bundle Identifier**: `Vulcan.Stacks` (auto-generated) ✅
- **Testing System**: `Swift Testing with XCTest UI Tests` ✅
- **Storage**: `None` (we'll add Core Data manually) ✅
- **Host in CloudKit**: Unchecked ✅

5. Click **Next**

### Additional Options:
- **Interface**: **SwiftUI** ✅
- **Language**: **Swift** ✅
- **Storage**: **None** ✅
- **Include Tests**: ✅ Yes

6. Choose save location
7. Click **Create**

---

## Step 2: Organize Project Structure

### 2.1 Create Folder Groups

In Xcode's Project Navigator (left sidebar), right-click on the `Stacks` folder and create these groups:

1. **App** (already exists, keep it)
2. **Core**
   - **Networking**
   - **Persistence**
3. **Features**
   - **Authentication**
   - **Library**
   - **Scanner**
   - **Reviews**
   - **Explore**
   - **Profile**
   - **Onboarding**
4. **Models**
5. **Services**
6. **DesignSystem**
   - **Components**
7. **Tests**
   - **UnitTests**
   - **UITests**

**How to create groups:**
- Right-click on `Stacks` folder → "New Group"
- Name it (e.g., "Core")
- Right-click on "Core" → "New Group" → "Networking"
- Repeat for all folders

---

## Step 3: Add Swift Files

### 3.1 Add App Files

**Location**: `Stacks/App/`

1. Right-click on `App` group → "Add Files to Stacks..."
2. Navigate to `Stacks/App/` in your file system
3. Select:
   - `StacksApp.swift`
   - `AppCoordinator.swift`
   - `MainTabView.swift`
4. Ensure "Copy items if needed" is **checked**
5. Ensure "Create groups" is selected
6. Click **Add**

### 3.2 Add Core Files

**Networking** (`Stacks/Core/Networking/`):
- `APIClient.swift`
- `Endpoints.swift`
- `NetworkError.swift`

**Persistence** (`Stacks/Core/Persistence/`):
- `CoreDataStack.swift`
- `KeychainManager.swift`

**How to add:**
1. Right-click on `Core/Networking` group
2. "Add Files to Stacks..."
3. Navigate to `Stacks/Core/Networking/`
4. Select all 3 files
5. "Copy items if needed" ✅
6. "Create groups" ✅
7. Click **Add**
8. Repeat for `Core/Persistence`

### 3.3 Add Models

**Location**: `Stacks/Models/`

Add all files:
- `User.swift`
- `Book.swift`
- `Review.swift`
- `Badge.swift`

### 3.4 Add Services

**Location**: `Stacks/Services/`

Add all files:
- `AuthService.swift`
- `LibraryService.swift`
- `ReviewService.swift`
- `ProfileService.swift`

### 3.5 Add Design System

**Location**: `Stacks/DesignSystem/`

Add:
- `Colors.swift`
- `Typography.swift`

**Components** (`Stacks/DesignSystem/Components/`):
- `BookCell.swift`
- `BadgeView.swift`

### 3.6 Add Features

**Authentication** (`Stacks/Features/Authentication/`):
- `AuthenticationView.swift`
- `AuthViewModel.swift`

**Library** (`Stacks/Features/Library/`):
- `BookshelfView.swift`
- `BookDetailView.swift`

**Scanner** (`Stacks/Features/Scanner/`):
- `ScannerView.swift`
- `ScannerViewModel.swift`
- `ManualBookEntryView.swift`

**Reviews** (`Stacks/Features/Reviews/`):
- `ReviewEditorView.swift`

**Explore** (`Stacks/Features/Explore/`):
- `ExploreView.swift`

**Profile** (`Stacks/Features/Profile/`):
- `ProfileView.swift`

**Onboarding** (`Stacks/Features/Onboarding/`):
- `OnboardingView.swift`

**For each feature:**
1. Right-click on the feature group
2. "Add Files to Stacks..."
3. Navigate to the corresponding folder
4. Select all files
5. "Copy items if needed" ✅
6. "Create groups" ✅
7. Click **Add**

---

## Step 4: Import Assets

### 4.1 Add Images to Asset Catalog

1. In Project Navigator, find `Assets.xcassets` (or create it if missing)
2. Right-click in the asset catalog → "New Image Set"
3. Name it exactly as the file (without extension)

**Required Assets:**
- `logo.png`
- `login background.png`
- `signup-background.png`
- `onboarding background.png`
- `bronze-badge.png`
- `silder-badge.png` (silver badge - note the typo in filename)
- `gold-badge.png`
- `plat-badge.png`
- `white shelf.png`
- `wood-shelf.png`
- `black-shlef.png` (black shelf - note typo)
- All other book cover images from `/assets` folder

**Quick Method:**
1. Open Finder and navigate to `/assets` folder
2. Select all image files
3. Drag and drop into `Assets.xcassets` in Xcode
4. Xcode will automatically create image sets

---

## Step 5: Configure Project Settings

### 5.1 Deployment Target

1. Select project in Navigator (top "Stacks" icon)
2. Select "Stacks" target
3. General tab → **Deployment Info**
4. Set **iOS** to **17.0** (minimum)

### 5.2 Info.plist Configuration

1. Find `Info.plist` in Project Navigator
2. Right-click → "Open As" → "Source Code"
3. Add camera permission:

```xml
<key>NSCameraUsageDescription</key>
<string>We need camera access to scan ISBN barcodes</string>
```

**Or use UI:**
1. Select target → "Info" tab
2. Click "+" to add new key
3. Type: `Privacy - Camera Usage Description`
4. Value: `We need camera access to scan ISBN barcodes`

### 5.3 Configure API Base URL

1. Select "Stacks" scheme (next to play button)
2. Click "Edit Scheme..."
3. Select "Run" → "Arguments"
4. Under "Environment Variables", click "+"
5. Add:
   - **Name**: `API_BASE_URL`
   - **Value**: `http://localhost:8080` (for simulator)
   
**For physical device:**
- Find your Mac's IP: `ipconfig getifaddr en0`
- Use: `http://YOUR_MAC_IP:8080`

### 5.4 Enable Capabilities (if needed)

1. Select target → "Signing & Capabilities"
2. Add capabilities if needed:
   - **Keychain Sharing** (for KeychainManager)
   - **Camera** (for barcode scanning)

---

## Step 6: Create Core Data Model

### 6.1 Add Core Data Model File

1. Right-click on `Stacks` folder → "New File..."
2. Select **iOS** → **Core Data** → **Data Model**
3. Name it: `StacksModel`
4. Click **Create**

### 6.2 Add Entities (Optional - for offline sync)

You can add entities later, or use the API directly. For now, the app will work with API calls.

**If you want Core Data entities:**
- `BookEntity` (id, isbn, title, author, coverData, lastSynced)
- `ReviewEntity` (id, bookId, rating, text, createdAt)
- `UserEntity` (id, email, username)

---

## Step 7: Fix Import Issues

### 7.1 Check for Missing Imports

Some files might need:
- `import SwiftUI`
- `import Foundation`
- `import Combine`
- `import AVFoundation` (for ScannerView)

Xcode should auto-import, but check if any files show errors.

### 7.2 Update Asset References

In `Colors.swift`, the color references use `Color("ColorName")`. Make sure:
- Asset names match exactly
- Colors are defined in Asset Catalog (or use system colors)

**Quick fix for Colors.swift:**
If assets aren't ready, you can use system colors temporarily:

```swift
static let primaryText = Color.primary
static let secondaryText = Color.secondary
static let shelfBackground = Color(.systemBackground)
static let cardBackground = Color(.secondarySystemBackground)
static let primaryButton = Color.blue
```

---

## Step 8: Build and Test

### 8.1 Clean Build

1. Product → Clean Build Folder (⇧⌘K)
2. Product → Build (⌘B)

### 8.2 Fix Any Errors

Common issues:
- **Missing imports**: Add `import SwiftUI`, `import Foundation`, etc.
- **Asset not found**: Check asset names match exactly
- **API URL**: Verify `API_BASE_URL` environment variable is set

### 8.3 Run the App

1. Select a simulator (e.g., iPhone 15)
2. Press ⌘R or click Play
3. App should launch to onboarding screen

---

## Step 9: Verify Setup

### Checklist:

- [ ] All Swift files added to correct groups
- [ ] All assets imported to Asset Catalog
- [ ] Deployment target set to iOS 17.0
- [ ] Camera permission added to Info.plist
- [ ] API_BASE_URL environment variable set
- [ ] Project builds without errors
- [ ] App launches successfully

---

## Troubleshooting

### "Cannot find type in scope"
- Check file is added to target (File Inspector → Target Membership)
- Clean build folder (⇧⌘K)

### "Asset not found"
- Verify asset name matches exactly (case-sensitive)
- Check asset is in Asset Catalog

### "Network request failed"
- Verify backend is running: `curl http://localhost:8080/health`
- Check `API_BASE_URL` environment variable
- For physical device, use Mac's IP address

### Build errors
- Clean build folder
- Delete DerivedData: `~/Library/Developer/Xcode/DerivedData`
- Restart Xcode

---

## Next Steps

1. Start backend: `docker-compose up -d`
2. Run migrations: `cd backend && npm run migrate && npm run seed`
3. Build and run iOS app
4. Test login with: `user@test.com` / `password123`

---

**Need help?** Check the main README.md or SETUP.md for more details.

