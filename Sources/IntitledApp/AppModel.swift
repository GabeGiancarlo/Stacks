//  Intitled
//  Created © 2025 John Doe. MIT License.

import Foundation
import Combine

// MARK: - AppModel

public class AppModel: ObservableObject {
    @Published var isOnboardingComplete = false
    @Published var selectedTab = 0
    
    public init() {
        // Initialize app state
    }
} 