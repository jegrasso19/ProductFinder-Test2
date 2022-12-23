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
    private let coreDM = CoreDataManager.shared.viewContext
    
    private var fetchedResultsController: NSFetchedResultsController<ProductFamily>!
    
    private func requestProductFamilies() -> NSFetchedResultsController<ProductFamily> {
        
        let request: NSFetchRequest = ProductFamily.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                managedObjectContext: coreDM,
                                                                sectionNameKeyPath: nil,
                                                                cacheName: nil)
        fetchedResultsController.delegate = self
        try? fetchedResultsController.performFetch()
        
        return fetchedResultsController
    }
    
    func loadProductFamilies() {
        
        fetchedResultsController = requestProductFamilies()
        
        DispatchQueue.main.async {
            self.productFamilies = (self.fetchedResultsController.fetchedObjects ?? []).map(ProductFamilyViewModel.init)
        }
    }
    
//    func deleteProductFamilies() {
//
//        fetchedResultsController = requestProductFamilies()
//        var productsToDelete : Set<String> = []
//
//        let productFamiliesToDelete = self.fetchedResultsController.fetchedObjects?.sorted(by: { productFamilies, productFamily in
//            if !productFamily.productFamilyId!.isEmpty { return true }
//        })
//
//        let productsToDelete = Set(productFamiliesToDelete.map { $0.productFamilyId })
//                for productFamily in productFamiliesToDelete {
//
//                    do {
//                        try coreDM.delete(productFamily)
//                    } catch {
//                        print(myError.programError("Delete ProductFamily error"))
//                    }
//        }
//    }
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
    
    var productFamilyId: String {
        return productFamily.code ?? "EMPTY"
    }
    
    var name: String {
        return productFamily.name ?? "EMPTY"
    }
    
    var partNumbers: NSSet {
        return productFamily.partNumbers ?? []
    }
}
