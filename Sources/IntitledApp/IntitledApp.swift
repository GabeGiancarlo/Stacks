//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI

@main
struct IntitledApp: App {
    @StateObject private var appModel = AppModel()
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appModel)
        }
    }
} 