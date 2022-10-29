//
//  ProductProvider.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import Foundation
import CoreData
import Combine

class ProductProvider: ObservableObject {
    
    static var shared = ProductProvider()

    static let preview: ProductProvider = {
        let provider = ProductProvider()
        PartNumber.makePreviews(count: 5)
        return provider
    }()
     
    private let inMemory: Bool
    private var notificationToken: NSObjectProtocol?

    private init(inMemory: Bool = false) {
        self.inMemory = inMemory

        notificationToken = NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: nil, queue: nil) { note in
            Task {
                await self.fetchPersistentHistory()
            }
        }
    }

    deinit {
        if let observer = notificationToken {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private var lastToken: NSPersistentHistoryToken?

    lazy var container: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "ProductFinderTest")
        
        guard let description = container.persistentStoreDescriptions.first else {
            fatalError("\(#function): Failed to retrieve a persistent store description.")
        }
        if inMemory {
            description.url = URL(fileURLWithPath: "/dev/null")
        }
        description.setOption(true as NSNumber, forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)
        description.setOption(true as NSNumber, forKey: NSPersistentHistoryTrackingKey)

        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                print("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = false
        container.viewContext.name = "viewContext"
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.undoManager = nil
        container.viewContext.shouldDeleteInaccessibleFaults = true
        return container
    }()

    func newTaskContext() -> NSManagedObjectContext {

        let taskContext = container.newBackgroundContext()
        taskContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        taskContext.undoManager = nil
        return taskContext
    }
    
    func fetchPersistentHistory() async {
        do {
            try await fetchPersistentHistoryTransactionsAndChanges()
        } catch {
            print(myError.programError("Fetch Persistent History Error"))
        }
    }

    private func fetchPersistentHistoryTransactionsAndChanges() async throws {
        
        let taskContext = newTaskContext()
        taskContext.name = "persistentHistoryContext"
        print("Start fetching persistent history changes from the store...")

        try await taskContext.perform {
            let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastToken)
            let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
            if let history = historyResult?.result as? [NSPersistentHistoryTransaction],
               !history.isEmpty {
                self.mergePersistentHistoryChanges(from: history)
                return
            }
            print("No persistent history transactions found.")
            throw myError.programError("Persistent History Change Error")
        }
        print("Finished merging history changes.")
    }

    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
        
        print("Received \(history.count) persistent history transactions.")
        let viewContext = container.viewContext
        viewContext.perform {
            for transaction in history {
                viewContext.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
                self.lastToken = transaction.token
            }
        }
    }
}

extension ProductProvider {

    func fetchProductData() async throws {
        
        guard let partNumberUrl = Bundle.main.url(forResource: "PartNumbers", withExtension: "json"),
            let partNumberData = try? Data(contentsOf: partNumberUrl)
        else {
            throw myError.programError("Failed to receive valid response and/or PartNumber data.")
        }
        do {
            let jsonDecoder = JSONDecoder()
            
            let partNumberJSON = try jsonDecoder.decode(PartNumberJSON.self, from: partNumberData)
            let partNumbers = partNumberJSON.partNumbers
            print("Received \(partNumbers.count) Part Number records.")
            print("Start importing product data to the store...")
            try await importProductData(from: partNumbers)
            print("Finished importing product data.")
        } catch {
            throw myError.programError("Wrong Data Format for Product Family")
        }
    }

    private func importProductData(from partNumbers: [PartNumberProperties]) async throws {
        guard !partNumbers.isEmpty else { return }
        
        let taskContext = newTaskContext()

        taskContext.name = "importProductDataContext"
        taskContext.transactionAuthor = "importProductData"

        try await taskContext.perform {

            let batchInsertRequest = self.partNumberBatchInsertRequest(with: partNumbers)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            else {
                throw myError.programError("Failed to execute PartNumber batch import request.")
            }
        }
        print("Successfully imported Product data.")
    }

    private func partNumberBatchInsertRequest(with partNumbers: [PartNumberProperties]) -> NSBatchInsertRequest {
        var index = 0
        let total = partNumbers.count

        let batchInsertRequest = NSBatchInsertRequest(entity: PartNumber.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: partNumbers[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }

    func deletePartNumbers(_ partNumbers: [PartNumber]) async throws {
        guard !partNumbers.isEmpty else {
            print("PartNumber database is empty.")
            return
        }
        let objectIDs = partNumbers.map { $0.objectID }
        let taskContext = newTaskContext()

        taskContext.name = "deletePartNumberContext"
        taskContext.transactionAuthor = "deletePartNumbers"
        print("Start deleting PartNumber data from the store...")

        try await taskContext.perform {
            let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
            guard let fetchResult = try? taskContext.execute(batchDeleteRequest),
                  let batchDeleteResult = fetchResult as? NSBatchDeleteResult,
                  let success = batchDeleteResult.result as? Bool, success
            else {
                throw myError.programError("Failed to execute PartNumber batch delete request.")
            }
        }
        print("Successfully deleted PartNumber data.")
    }
}
