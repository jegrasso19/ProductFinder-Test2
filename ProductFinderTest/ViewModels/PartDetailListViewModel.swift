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
    private var coreDM = CoreDataManager.shared.viewContext
    private var fetchedResultsController: NSFetchedResultsController<PartDetail>!
    
    func requestPartNumbers() -> NSFetchedResultsController<PartDetail> {
        
        let request: NSFetchRequest<PartDetail> = PartDetail.fetchPartDetailRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "partNumber", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                              managedObjectContext: coreDM,
                                                              sectionNameKeyPath: nil,
                                                              cacheName: nil)
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    func returnPartNumbers() -> [PartDetailViewModel] {
        
        fetchedResultsController = requestPartNumbers()
        
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
