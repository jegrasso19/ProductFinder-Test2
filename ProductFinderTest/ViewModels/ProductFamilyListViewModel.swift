//
//  ProductFamilyViewModel.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 11/19/22.
//

import Foundation
import CoreData

class ProductFamilyListViewModel: NSObject, ObservableObject {
    
    @Published var productFamilies = [ProductFamilyViewModel]()
    
    private var fetchedResultsController: NSFetchedResultsController<ProductFamily>!
    
    func getAllProductFamilies() {
        
        let request: NSFetchRequest = ProductFamily.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                managedObjectContext: CoreDataManager.shared.viewContext,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        DispatchQueue.main.async {
            self.productFamilies = (self.fetchedResultsController.fetchedObjects ?? []).map(ProductFamilyViewModel.init)
        }
    }
    
    func deleteAllProductFamilies(productFamilies: [ProductFamily]) {
        
    }
}

extension ProductFamilyListViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        DispatchQueue.main.async {
            self.productFamilies = (controller.fetchedObjects as? [ProductFamily] ?? []).map(ProductFamilyViewModel.init)
        }
    }
}

struct ProductFamilyViewModel {
    
    let productFamily: ProductFamily
    
    var productFamilyId: NSManagedObjectID {
        return productFamily.objectID
    }
    
    var name: String {
        return productFamily.name ?? "EMPTY"
    }
}
