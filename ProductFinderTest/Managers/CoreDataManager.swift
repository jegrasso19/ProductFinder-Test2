//
//  ProductProvider.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import Foundation
import CoreData

class CoreDataManager: ObservableObject {
    
    let persistentContainer: NSPersistentContainer
    
    static var shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "ProductFinderTest")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data \(error)")
            }
        }
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        print(directories[0])
    }
    
    func newTaskContext() -> NSManagedObjectContext {
        
        let taskContext = persistentContainer.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        return taskContext
    }
}
