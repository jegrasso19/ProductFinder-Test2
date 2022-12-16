//
//  PartNumberListViewModel.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 11/19/22.
//

import Foundation
import CoreData

class PartNumberListViewModel: NSObject, ObservableObject {
    
    @Published var partNumbers = [PartNumberViewModel]()
    private var coreDM = CoreDataManager.shared.viewContext
    private var fetchedResultsController: NSFetchedResultsController<PartDetail>!
    
    func getAllPartNumbers() {
        
        let request: NSFetchRequest<PartDetail> = PartDetail.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "partNumber", ascending: true)]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: coreDM, sectionNameKeyPath: nil, cacheName: nil)
        
        try? fetchedResultsController.performFetch()
        
//        DispatchQueue.main.async {
//            self.partNumbers = (self.fetchedResultsController.fetchedObjects ?? []).map(PartNumberViewModel.init)
//        }
    }
}

struct PartNumberViewModel {
    
    let partDetail: PartDetailProperties
    
    var orderable: Bool {
        return partDetail.orderable
    }
    
    var partNumber: String {
        return partDetail.partNumber
    }
    
    var pnDescription: String {
        return partDetail.pnDescription
    }
    
    var productFamily: String {
        return partDetail.productFamily
    }
    
    var id: String {
        return partDetail.id
    }
}
