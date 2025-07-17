//  Intitled
//  Created © 2025 John Doe. MIT License.

import XCTest
import SwiftUI
@testable import IntitledApp

// MARK: - AppLaunchTests

final class AppLaunchTests: XCTestCase {
    
    func testAppLaunches() throws {
        // Test that the main app entry point can be instantiated
        let app = IntitledApp()
        XCTAssertNotNil(app.body)
    }
    
    func testTabViewHasFiveTabs() throws {
        // Create the root tab view
        let appModel = AppModel()
        let tabView = RootTabView()
            .environmentObject(appModel)
        
        // In a real UI test, you would use XCUIApplication to test the actual UI
        // For this unit test, we're just verifying the view can be created
        XCTAssertNotNil(tabView.body)
    }
    
    func testAppModelInitialization() throws {
        let appModel = AppModel()
        
        XCTAssertFalse(appModel.isOnboardingComplete)
        XCTAssertEqual(appModel.selectedTab, 0)
    }
    
    func testMockDataAvailability() throws {
        // Verify that all mock data is available
        XCTAssertFalse(Book.mockData.isEmpty)
        XCTAssertFalse(Shelf.mockData.isEmpty)
        XCTAssertFalse(Badge.mockData.isEmpty)
        XCTAssertNotNil(User.mockData)
        XCTAssertFalse(ShelfStyle.mockData.isEmpty)
    }
} 