//
//  CoreDataManager+Extensions.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 11/19/22.
//

import Foundation
import CoreData

extension CoreDataManager {

    func fetchProductData() async throws {
        
        guard let url = Bundle.main.url(forResource: "PartNumbers", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url)
        else {
            throw myError.programError("Failed to receive valid response and/or PartNumber data.")
        }
        do {
            let jsonDecoder = JSONDecoder()
            
// There are two JSON decoders I created. PartDetailJSON and PartNumberJSON. I don't know which
// one is best to use for this situation. This is where I'm looking for help as neither one works.
//            PartDetailJSON uses this code
//            let partDetailJSON = try jsonDecoder.decode(PartDetailJSON.self, from: jsonData)
//            let partDetailPropertiesList = partDetailJSON.partDetailPropertiesList
//            print("Received \(partDetailPropertiesList.count) Part Number records.")

            // PartNumberJSON uses this code
            let partNumberJSON = try jsonDecoder.decode(PartNumberJSON.self, from: jsonData)
            let partNumberPropertiesList = partNumberJSON.partNumberPropertiesList
            print("Received \(partNumberPropertiesList.count) Part Number records.")
            
            print("Start importing product data to the store...")
            try await importProductData(from: partNumberPropertiesList)
            print("Finished importing product data.")
        } catch {
            throw myError.programError("Wrong Data Format for Part Numbers")
        }
    }

    private func importProductData(from partNumbers: [PartDetailProperties]) async throws {
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

    private func partNumberBatchInsertRequest(with partNumbers: [PartDetailProperties]) -> NSBatchInsertRequest {
        var index = partNumbers.startIndex
        let total = partNumbers.count

        let batchInsertRequest = NSBatchInsertRequest(entity: PartDetail.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            dictionary.addEntries(from: partNumbers[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }

    func deletepartNumbers(_ partNumbers: [PartDetail]) async throws {
        guard !partNumbers.isEmpty else {
            print("PartNumber database is empty.")
            return
        }
        let objectIDs = partNumbers.map { $0.objectID }
        let taskContext = newTaskContext()

        taskContext.name = "deletePartNumberContext"
        taskContext.transactionAuthor = "deletePartNumbers"
        print("Start deleting Part Number data from the store...")

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

