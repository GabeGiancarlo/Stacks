//  Intitled
//  Created © 2025 John Doe. MIT License.

import CoreData
import CloudKit

// MARK: - PersistenceController

public class PersistenceController: ObservableObject {
    public static let shared = PersistenceController()
    
    public let container: NSPersistentCloudKitContainer
    
    private init() {
        container = NSPersistentCloudKitContainer(name: "IntitledDataModel")
        
        // Configure CloudKit sync
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("Failed to retrieve persistent store description")
        }
        
        // Enable CloudKit sync
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.cloudKitContainerOptions = NSPersistentCloudKitContainerOptions(
            containerIdentifier: "iCloud.com.yourcompany.intitled"
        )
        
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // In production, handle this error appropriately
                fatalError("Failed to load store: \(error), \(error.userInfo)")
            }
        }
        
        // Configure automatic merging from parent context
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    public var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    public func save() {
        let context = container.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // In production, handle this error appropriately
                let nsError = error as NSError
                print("Save error: \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    public func saveContext() {
        save()
    }
} 