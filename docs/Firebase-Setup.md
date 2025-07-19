# Firebase Setup Guide for Intitled

This document outlines the Firebase configuration for the Intitled app using the `intilted-v1` project.

## Project Configuration

- **Firebase Project**: `intilted-v1`
- **Console URL**: [https://console.firebase.google.com/u/0/project/intilted-v1](https://console.firebase.google.com/u/0/project/intilted-v1/authentication/users)
- **Bundle Identifier**: `com.intitled.intilted-v1`
- **CloudKit Container**: `iCloud.com.intitled.intilted-v1`

## Authentication Methods

### 1. Email/Password Authentication ✅

**Status**: Configured and ready
**Documentation**: [Firebase Auth iOS Guide](https://firebase.google.com/docs/auth/ios/password-auth)

**Features**:
- User registration with email and password
- Login with existing credentials
- Password reset functionality
- Email verification

**Implementation Status**:
- ✅ AppModel.signIn(email:password:) method ready
- ✅ AppModel.signUp(email:password:displayName:) method ready
- ✅ Firebase Auth listener configured
- ⚠️ UI implementation needed (currently placeholder)

### 2. Phone Authentication ✅

**Status**: Configured and ready
**Documentation**: [Firebase iOS Phone Auth](https://firebase.google.com/docs/auth/ios/phone-auth)

**Features**:
- SMS-based verification
- International phone number support
- Automatic SMS detection
- Fallback to manual code entry

**Implementation Notes**:
- Requires APNs certificates for production
- Test phone numbers can be configured in Firebase Console
- Rate limiting enabled for security

### 3. Email Customization ✅

**Status**: Ready for customization
**Documentation**: [Firebase Auth Email Customization](https://support.google.com/firebase/answer/7000714)

**Customizable Templates**:
- Password reset emails
- Email verification
- Email change notifications
- Welcome emails

## Firestore Database Configuration

### Security Rules

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Public book data (for social features)
    match /books/{bookId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.ownerId;
    }
    
    // Reviews can be read by anyone, written by authenticated users
    match /reviews/{reviewId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && 
        request.auth.uid == resource.data.authorId;
    }
    
    // Friend requests and social features
    match /friendRequests/{requestId} {
      allow read, write: if request.auth != null && 
        (request.auth.uid == resource.data.senderId || 
         request.auth.uid == resource.data.recipientId);
    }
  }
}
```

### Collections Structure

```
📁 Firestore Database
├── 👥 users/
│   └── {userId}/
│       ├── profile (User document)
│       ├── shelves/ (subcollection)
│       ├── badges/ (subcollection)
│       └── settings/ (subcollection)
├── 📚 books/
│   └── {bookId}/ (shared book metadata)
├── ⭐ reviews/
│   └── {reviewId}/ (user reviews)
├── 👫 friendRequests/
│   └── {requestId}/ (friend connections)
└── 📊 analytics/
    └── {eventId}/ (usage analytics)
```

## iOS App Configuration

### 1. GoogleService-Info.plist

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>PROJECT_ID</key>
    <string>intilted-v1</string>
    <key>BUNDLE_ID</key>
    <string>com.intitled.intilted-v1</string>
    <!-- Additional Firebase configuration keys will be here -->
</dict>
</plist>
```

**Setup Instructions**:
1. Download from Firebase Console
2. Add to Xcode project root
3. Ensure it's included in app target
4. Never commit to version control (already in .gitignore)

### 2. Info.plist Configuration

Add the following URL scheme for authentication:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>com.intitled.intilted-v1</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.intitled.intilted-v1</string>
        </array>
    </dict>
</array>
```

## Development Workflow

### 1. Local Development

```bash
# Run with sample data
swift run --configuration debug --create-sample-data

# Run tests including Firebase integration
swift test
```

### 2. Authentication Testing

**Test Accounts** (configure in Firebase Console):
- Email: `test@intitled.app`
- Password: `TestPassword123!`
- Phone: `+1 555-123-4567` (verification code: `123456`)

### 3. Firestore Emulator (Optional)

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Start emulator
firebase emulators:start --only firestore

# Configure app to use emulator in debug mode
```

## Security Considerations

### 1. Authentication Security
- ✅ Password requirements enforced
- ✅ Rate limiting enabled
- ✅ Email verification required
- ⚠️ Two-factor authentication (future enhancement)

### 2. Data Protection
- ✅ Firestore security rules implemented
- ✅ User data scoped to authenticated user
- ✅ CloudKit encryption for local data
- ✅ HTTPS only for all API calls

### 3. Privacy Compliance
- ✅ User data deletion on account removal
- ✅ Granular privacy controls
- ✅ GDPR-compliant data handling
- ⚠️ Privacy policy integration needed

## Monitoring & Analytics

### 1. Firebase Analytics

**Events to Track**:
- User registration
- Book scans
- Reviews written
- Badges earned
- Social interactions

### 2. Crashlytics

**Setup**:
```swift
// In AppDelegate or @main App
import FirebaseCrashlytics

// Enable in release builds
Crashlytics.crashlytics()
```

### 3. Performance Monitoring

**Key Metrics**:
- App startup time
- Book scanning performance
- Database query speed
- Image loading times

## Troubleshooting

### Common Issues

1. **Authentication Errors**
   - Verify GoogleService-Info.plist is included
   - Check bundle identifier matches Firebase project
   - Ensure network connectivity

2. **Firestore Permission Denied**
   - Verify user is authenticated
   - Check security rules match user ID
   - Ensure Firestore is enabled in Firebase Console

3. **CloudKit Sync Issues**
   - Verify iCloud account is signed in
   - Check CloudKit container identifier
   - Ensure proper entitlements are set

### Debug Logging

```swift
// Enable Firebase debug logging
FirebaseApp.configure()
#if DEBUG
Auth.auth().settings?.isAppVerificationDisabledForTesting = true
#endif
```

## Next Steps

1. **Complete UI Implementation**
   - Implement authentication screens
   - Add Firebase Auth integration to placeholder views
   - Test all authentication flows

2. **Firestore Integration**
   - Implement social features with Firestore
   - Add real-time listeners for friend activity
   - Sync user-generated content

3. **Security Review**
   - Audit Firestore security rules
   - Implement proper error handling
   - Add rate limiting for API calls

4. **Testing**
   - Write integration tests for Firebase features
   - Test authentication flows on device
   - Verify CloudKit + Firestore sync behavior

---

For additional support, refer to:
- [Firebase iOS Documentation](https://firebase.google.com/docs/ios/setup)
- [Firestore Security Rules](https://firebase.google.com/docs/firestore/security/get-started)
- [Firebase Auth Best Practices](https://firebase.google.com/docs/auth/ios/best-practices) 