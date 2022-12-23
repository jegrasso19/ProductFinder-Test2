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
            
            // PartNumberJSON uses this code
            let productFamilyJSON = try jsonDecoder.decode(ProductFamilyJSON.self, from: jsonData)
            let productFamilyList = productFamilyJSON.productFamilies
            
            print("Received \(productFamilyList.count) Part Number records.")
            print("Start importing product data to the store...")
            
            try await importProductData(from: productFamilyList)
            
            print("Finished importing product data.")
        } catch {
            throw myError.programError("Wrong Data Format for Part Numbers")
        }
    }

    private func importProductData(from productList: [ProductFamilyProperties]) async throws {
        guard !productList.isEmpty else { return }
        
        let taskContext = newTaskContext()

        taskContext.name = "importProductDataContext"
        taskContext.transactionAuthor = "importProductData"

        try await taskContext.perform {

            let batchInsertRequest = self.productListBatchInsertRequest(with: productList)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            else {
                throw myError.programError("Failed to execute ProductList batch import request.")
            }
        }
        print("Successfully imported Product data.")
    }

    private func productListBatchInsertRequest(with productList: [ProductFamilyProperties]) -> NSBatchInsertRequest {
        var index = 0
        let total = productList.count

        let batchInsertRequest = NSBatchInsertRequest(entity: ProductFamily.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            
            dictionary.addEntries(from: productList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }

//    func deleteProductData(_ productFamilies: [ProductFamilyProperties]) async throws {
//        guard !productFamilies.isEmpty else {
//            print("ProductFamily database is empty.")
//            return
//        }
//        let objectIDs = productFamilies.map { $0.objectID }
//        let taskContext = newTaskContext()
//
//        taskContext.name = "deletePartNumberContext"
//        taskContext.transactionAuthor = "deletePartNumbers"
//        print("Start deleting Part Number data from the store...")
//
//        try await taskContext.perform {
//            let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
//            guard let fetchResult = try? taskContext.execute(batchDeleteRequest),
//                  let batchDeleteResult = fetchResult as? NSBatchDeleteResult,
//                  let success = batchDeleteResult.result as? Bool, success
//            else {
//                throw myError.programError("Failed to execute PartNumber batch delete request.")
//            }
//        }
//        print("Successfully deleted PartNumber data.")
//    }
}

