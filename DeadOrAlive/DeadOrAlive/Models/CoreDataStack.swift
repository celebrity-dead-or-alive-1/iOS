//
//  CoreDataStack.swift
//  DeadOrAlive
//
//  Created by morse on 1/6/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

import CoreData

class CoreDataStack {
    
    // Let us access the CoreDataStack from anywhere in the app.
    static let shared = CoreDataStack()
    
    // Set up a persistent container
    
    lazy var container: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "DeadOrAlive")
        
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent stores: \(error)")
            }
        }
        return container
    }()
    
    // Create easy access to the moc (managed object context)
    var mainContext: NSManagedObjectContext {
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container.viewContext
    }
    
    func save(context: NSManagedObjectContext) throws {
        var error: Error?
        
        context.performAndWait {
            do {
                try context.save()
            } catch let saveError {
                error = saveError
            }
        }
        
        if let error = error { throw error }
    }
}
