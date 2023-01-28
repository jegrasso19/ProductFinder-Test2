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
        
        guard let url = Bundle.main.url(forResource: "ProductFamilies", withExtension: "json"),
            let jsonData = try? Data(contentsOf: url)
        else {
            throw myError.programError("Failed to receive valid response and/or Product Family data.")
        }
        do {
            let jsonDecoder = JSONDecoder()
            
            // ProductFamilyJSON uses this code
            let productFamilyJSON = try jsonDecoder.decode(ProductFamilyJSON.self, from: jsonData)
            let productFamilyList = productFamilyJSON.productFamilies

            print("Received \(productFamilyList.count) ProductFamily records.")
            print("Start importing ProductFamily data to the store...")
            
            try await importProductFamilyData(from: productFamilyList)
            print("Finished importing ProductFamily Data.")
            
            for productFamily in productFamilyList {
                let partNumbersList = productFamily.partNumbers
                
                print("Received \(partNumbersList.count) PartNumber records for ProductFamily \(productFamily.name).")
                print("Start importing PartNumber data to the store...")
                try await importPartNumberData(productFamilyProperty: productFamily, partNumbers: partNumbersList)
            }
            print("Finished importing PartDetail Data.")
            
            try await mergePartDetailsWithProductFamilies()
            
            print("Finished importing all product data.")
        } catch {
            throw myError.programError("Wrong Data Format for Product Families")
        }
    }

    private func importProductFamilyData(from productFamilyList: [ProductFamilyProperties]) async throws {
        guard !productFamilyList.isEmpty else { return }
        
        let taskContext = newTaskContext()

        try await taskContext.perform {

            let batchInsertRequest = self.productFamilyListBatchInsertRequest(with: productFamilyList)
            if let fetchResult = try? taskContext.execute(batchInsertRequest),
               let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool, success {
                return
            }
            else {
                throw myError.programError("Failed to execute ProductFamilyList batch import request.")
            }
        }
        print("Successfully imported ProductFamily data.")
    }

    private func productFamilyListBatchInsertRequest(with productFamilyList: [ProductFamilyProperties]) -> NSBatchInsertRequest {
        var index = 0
        let total = productFamilyList.count

        let batchInsertRequest = NSBatchInsertRequest(entity: ProductFamily.entity(), dictionaryHandler: { dictionary in
            guard index < total else { return true }
            
            dictionary.addEntries(from: productFamilyList[index].dictionaryValue)
            index += 1
            return false
        })
        return batchInsertRequest
    }

    private func importPartNumberData(productFamilyProperty: ProductFamilyProperties, partNumbers: [PartDetailProperties]) async throws {
        
        let taskContext = newTaskContext()

        try await taskContext.perform {
            
            let request = ProductFamily.fetchProductFamilyRequest()
            let productFamilies = try taskContext.fetch(request)

            for productFamily in productFamilies {
                if productFamily.name == productFamilyProperty.name {
                    let batchInsertRequest = self.partNumberListBatchInsertRequest(productFamily: productFamily, partNumbersList: partNumbers)
                    if let fetchResult = try? taskContext.execute(batchInsertRequest),
                       let batchInsertResult = fetchResult as? NSBatchInsertResult,
                       let success = batchInsertResult.result as? Bool, success {
                        return
                    }
                    else {
                        throw myError.programError("Failed to execute PartNumberList batch import request.")
                    }
                }
            }
        }
        print("Successfully imported PartNumber data.")
    }
    
    private func partNumberListBatchInsertRequest(productFamily: ProductFamily, partNumbersList: [PartDetailProperties]) -> NSBatchInsertRequest {
        
        var index = 0
        let total = partNumbersList.count
        
        let batchInsertRequest = NSBatchInsertRequest(entity: PartDetail.entity()) { (managedObject: NSManagedObject) -> Bool in
            guard index < total else { return true }

            if let partDetail = managedObject as? PartDetail {
                let data = partNumbersList[index]
                partDetail.partNumber = data.partNumber
                partDetail.orderable = data.orderable
                partDetail.pnDescription = data.pnDescription
                partDetail.productFamilyName = productFamily.name
            }
            index += 1
            return false
        }
        return batchInsertRequest
    }
    
    func mergePartDetailsWithProductFamilies() async throws {
        
        let taskContext = newTaskContext()
        try await taskContext.perform {
            
            let productFamilyRequest = ProductFamily.fetchProductFamilyRequest()
            let productFamilies = try taskContext.fetch(productFamilyRequest)
            
            let partDetailRequest = PartDetail.fetchPartDetailRequest()
            let partDetails = try taskContext.fetch(partDetailRequest)
            
            for productFamily in productFamilies {
                
                for partDetail in partDetails {

                    if partDetail.productFamilyName == productFamily.name {
                        productFamily.addToPartNumbers(partDetail)          // Adds PartDetail to ProductFamily Array
                        //partDetail.productFamily = productFamily          // Adds Product Family to PartDetail
                        // CoreData only needs of of these to execute. The other is automatically added
                    }
                }
            }
            try taskContext.save()
        }
    }

    func requestProductFamilies() -> NSFetchedResultsController<ProductFamily> {
        
        var fetchedResultsController: NSFetchedResultsController<ProductFamily>!
        
        let request: NSFetchRequest = ProductFamily.fetchProductFamilyRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    func requestPartNumbers() -> NSFetchedResultsController<PartDetail> {
        
        var fetchedResultsController: NSFetchedResultsController<PartDetail>!
        
        let request: NSFetchRequest<PartDetail> = PartDetail.fetchPartDetailRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "partNumber", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: viewContext,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    func deleteProductFamilyData() async throws {
        
        let taskContext = self.newTaskContext()
        let fetchedResultsController = requestProductFamilies()
        try fetchedResultsController.performFetch()
        
        let productFamilies = (fetchedResultsController.fetchedObjects ?? []).map(ProductFamilyViewModel.init)
  
        guard !productFamilies.isEmpty else {
            print("ProductFamily database is empty.")
            return
        }
        let objectIDs = productFamilies.map { $0.objectId }

        print("Start deleting ProductFamily data from the store...")
        try await taskContext.perform {
            let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
            guard let fetchResult = try? taskContext.execute(batchDeleteRequest),
                  let batchDeleteResult = fetchResult as? NSBatchDeleteResult,
                  let success = batchDeleteResult.result as? Bool, success
            else {
                throw myError.programError("Failed to execute ProductFamily batch delete request.")
            }
        }
        print("Successfully deleted ProductFamily data.")
    }
    
    func deletePartDetailData() async throws {
        
        let taskContext = self.newTaskContext()
        let fetchedResultsController = requestPartNumbers()
        try fetchedResultsController.performFetch()
        
        let partNumbers = (fetchedResultsController.fetchedObjects ?? []).map(PartDetailViewModel.init)
  
        guard !partNumbers.isEmpty else {
            print("PartDetail database is empty.")
            return
        }
        let objectIDs = partNumbers.map { $0.objectId }

        print("Start deleting PartDetail data from the store...")
        try await taskContext.perform {
            let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: objectIDs)
            guard let fetchResult = try? taskContext.execute(batchDeleteRequest),
                  let batchDeleteResult = fetchResult as? NSBatchDeleteResult,
                  let success = batchDeleteResult.result as? Bool, success
            else {
                throw myError.programError("Failed to execute PartDetail batch delete request.")
            }
        }
        print("Successfully deleted PartDetail data.")
    }
}
