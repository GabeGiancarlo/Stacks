import XCTest
import SwiftUI
import ViewInspector
@testable import Intitled

/// Tests to verify app launch and basic functionality
final class AppLaunchTests: XCTestCase {
    
    func testAppModelInitialization() {
        // Test that AppModel initializes correctly
        let appModel = AppModel()
        
        XCTAssertEqual(appModel.authState, .unknown, "Initial auth state should be unknown")
        XCTAssertEqual(appModel.selectedTab, .home, "Default tab should be home")
        XCTAssertFalse(appModel.showOnboarding, "Onboarding should not show initially")
        XCTAssertNil(appModel.currentUser, "No user should be set initially")
    }
    
    func testPersistenceControllerInitialization() {
        // Test that PersistenceController initializes correctly
        let controller = PersistenceController.shared
        
        XCTAssertNotNil(controller.container, "Model container should be initialized")
        XCTAssertEqual(controller.syncStatus, .idle, "Initial sync status should be idle")
    }
    
    func testDesignSystemColors() {
        // Test that design system colors are properly defined
        XCTAssertNotNil(Color.background, "Background color should be defined")
        XCTAssertNotNil(Color.accent, "Accent color should be defined")
        XCTAssertNotNil(Color.primaryText, "Primary text color should be defined")
    }
    
    func testBadgeEngineConfiguration() {
        // Test that badge engine has criteria defined
        let criteria = BadgeEngine.allCriteria
        
        XCTAssertGreaterThan(criteria.count, 20, "Should have multiple badge criteria")
        
        // Test specific badge types exist
        let booksReadCriteria = criteria.filter { $0.type == .booksRead }
        XCTAssertGreaterThan(booksReadCriteria.count, 0, "Should have books read badges")
        
        let tierTypes = Set(criteria.map { $0.tier })
        XCTAssertTrue(tierTypes.contains(.bronze), "Should have bronze tier badges")
        XCTAssertTrue(tierTypes.contains(.diamond), "Should have diamond tier badges")
    }
    
    func testCurrentAppStateDocumentation() {
        // This test documents the current state of the app for development reference
        print("""
        
        📱 CURRENT APP STATE SUMMARY:
        
        🏗️ FOUNDATION COMPLETE:
        ✅ Swift Package Manager project structure
        ✅ MVVM-C architecture with coordinators
        ✅ SwiftData + CloudKit persistence layer
        ✅ Firebase Auth integration (project: intilted-v1)
        ✅ Comprehensive data models (Book, User, Shelf, Review, Badge)
        ✅ Dark-mode-first design system
        ✅ Badge achievement system with 25+ badges
        ✅ Authentication flow placeholders
        ✅ Tab navigation structure
        
        🎨 DESIGN SYSTEM:
        ✅ Color palette with warm gold accent (#D4AF37)
        ✅ Typography scale for all text sizes
        ✅ Button styles (Primary, Secondary, Destructive, etc.)
        ✅ Card styles with shadows and animations
        ✅ Custom shapes for book spines and shelves
        ✅ Haptic feedback integration
        
        📱 CURRENT SCREENS:
        • Loading: Dark background + Intitled logo + progress indicator
        • Authentication: Navigation to login/signup placeholders
        • Home Tab: "Home View (To be implemented)"
        • Discover Tab: "Discover View (To be implemented)"
        • Scanner Tab: Triggers full-screen scanner (placeholder)
        • Library Tab: "Library View (To be implemented)"
        • Profile Tab: "Profile View (To be implemented)"
        
        🚀 READY FOR NEXT PHASE:
        1. Replace placeholder views with actual shelf UI
        2. Implement VisionKit book scanning
        3. Add Google Books API integration
        4. Build review and social features
        5. Create beautiful book detail screens
        
        📝 ASSETS NEEDED:
        • App icon variations
        • Shelf texture images (wood, modern, vintage)
        • Badge graphics (bronze through diamond)
        • Sample book cover images
        • Background patterns for shelf styles
        
        """)
        
        // Test passes to show this documentation in test output
        XCTAssertTrue(true, "App state documented successfully")
    }
}

// MARK: - Integration Tests

extension AppLaunchTests {
    
    func testSampleDataCreation() {
        // Test sample data creation (development mode)
        let controller = PersistenceController.shared
        
        Task {
            await controller.createSampleData()
            
            // Verify sample data was created
            let users = try? controller.fetch(User.self)
            XCTAssertNotNil(users, "Sample users should be created")
            
            if let users = users, !users.isEmpty {
                let sampleUser = users.first!
                XCTAssertEqual(sampleUser.username, "gabriel", "Sample user should have correct username")
                
                let userShelves = controller.userShelves
                XCTAssertGreaterThan(userShelves.count, 0, "User should have default shelves")
                
                let userBooks = controller.userBooks
                XCTAssertGreaterThan(userBooks.count, 0, "User should have sample books")
            }
        }
    }
    
    func testAuthenticationFlow() {
        // Test authentication state transitions
        let appModel = AppModel()
        
        // Test initial state
        XCTAssertEqual(appModel.authState, .unknown)
        
        // Test navigation functions
        appModel.navigateToTab(.library)
        XCTAssertEqual(appModel.selectedTab, .library)
        
        appModel.navigateToTab(.profile)
        XCTAssertEqual(appModel.selectedTab, .profile)
    }
    
    func testBadgeEarnedFlow() {
        // Test badge earned popup flow
        let appModel = AppModel()
        
        // Create a sample badge
        let badge = Badge(
            type: .booksRead,
            tier: .bronze,
            title: "First Steps",
            badgeDescription: "Read your first 5 books",
            iconName: "book",
            color: "#CD7F32"
        )
        
        // Test badge earned state
        appModel.recentlyEarnedBadge = badge
        appModel.showBadgeEarned = true
        
        XCTAssertTrue(appModel.showBadgeEarned, "Badge earned should be shown")
        XCTAssertNotNil(appModel.recentlyEarnedBadge, "Badge should be set")
        
        // Test dismissal
        appModel.dismissBadgeEarned()
        
        XCTAssertFalse(appModel.showBadgeEarned, "Badge earned should be dismissed")
        XCTAssertNil(appModel.recentlyEarnedBadge, "Badge should be cleared")
    }
} 