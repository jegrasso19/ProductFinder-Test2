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
    private let coreDM = CoreDataManager.shared
    
    private var fetchedResultsController: NSFetchedResultsController<ProductFamily>!
    
    private func requestProductFamilies() -> NSFetchedResultsController<ProductFamily> {
        
        let request: NSFetchRequest = ProductFamily.fetchProductFamilyRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: coreDM.viewContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    func returnProductFamilies() -> [ProductFamilyViewModel] {
        
        fetchedResultsController = requestProductFamilies()
        
        self.productFamilies = (self.fetchedResultsController.fetchedObjects ?? []).map(ProductFamilyViewModel.init)
        return self.productFamilies
    }
    
    func deleteProductFamilies() async throws {
        
        do {
            try await self.coreDM.deleteProductData()
        } catch {
            throw myError.programError("Delete Product Families failed")
        }
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
    
    var objectId: NSManagedObjectID {
        return productFamily.objectID
    }
    
    var code: String {
        return productFamily.code
    }
    
    var name: String {
        return productFamily.name
    }
    
    var partNumbers: NSSet {
        return productFamily.partNumbers
    }
}
