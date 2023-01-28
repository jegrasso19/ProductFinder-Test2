//
//  PartNumberListViewModel.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 11/19/22.
//

import Foundation
import CoreData

class PartDetailListViewModel: NSObject, ObservableObject {
    
    @Published var partNumbers = [PartDetailViewModel]()
    private var coreDM = CoreDataManager.shared
    private var fetchedResultsController: NSFetchedResultsController<PartDetail>!
    
    func returnPartNumbers() -> [PartDetailViewModel] {
        
        fetchedResultsController = coreDM.requestPartNumbers()
        
        self.partNumbers = (self.fetchedResultsController.fetchedObjects ?? []).map(PartDetailViewModel.init)
        return self.partNumbers
    }
    
    func deletePartDetails() async throws {
        
        do {
            try await self.coreDM.deletePartDetailData()
        } catch {
            throw myError.programError("Delete PartDetails failed")
        }
    }
    
    //    func getPartNumbers(productFamily: ProductFamilyViewModel) -> [PartDetailViewModel] {
    //
    //        var partNumberList : [PartDetailViewModel] = []
    //        fetchedResultsController = coreDM.requestPartNumbers()
    //
    //        let partNumbers = (self.fetchedResultsController.fetchedObjects ?? []).map(PartDetailViewModel.init)
    //
    //        for partNumber in partNumbers {
    //            if partNumber.productFamilyName == productFamily.name {
    //                partNumberList.append(partNumber)
    //            }
    //        }
    //        return partNumberList
    //    }
}

struct PartDetailViewModel {
    
    let partDetail: PartDetail
    
    var objectId: NSManagedObjectID {
        return partDetail.objectID
    }
    
    var orderable: Bool {
        return partDetail.orderable
    }
    
    var partNumber: String {
        return partDetail.partNumber
    }
    
    var pnDescription: String {
        return partDetail.pnDescription
    }
    
    var productFamilyName: String {
        return partDetail.productFamilyName
    }
    
    var productFamily: ProductFamily {
        return partDetail.productFamily
    }
}
