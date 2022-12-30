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
}
