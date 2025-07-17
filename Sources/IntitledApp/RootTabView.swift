//  Intitled
//  Created © 2025 John Doe. MIT License.

import SwiftUI
import LibraryFeature
import ScannerFeature
import DiscoverFeature
import ProfileFeature
import ShopFeature

// MARK: - RootTabView

struct RootTabView: View {
    @EnvironmentObject var appModel: AppModel
    
    var body: some View {
        TabView(selection: $appModel.selectedTab) {
            LibraryView()
                .tabItem {
                    Image(systemName: "books.vertical")
                    Text("Library")
                }
                .tag(0)
            
            ScannerView()
                .tabItem {
                    Image(systemName: "camera.viewfinder")
                    Text("Scanner")
                }
                .tag(1)
            
            DiscoverView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("Discover")
                }
                .tag(2)
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("Profile")
                }
                .tag(3)
            
            ShopView()
                .tabItem {
                    Image(systemName: "bag")
                    Text("Shop")
                }
                .tag(4)
        }
    }
} 