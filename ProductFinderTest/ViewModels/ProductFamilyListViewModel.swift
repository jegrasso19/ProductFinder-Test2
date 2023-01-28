//
//  ProductFamilyViewModel.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 11/19/22.
//

import SwiftUI
import CoreData

class ProductFamilyListViewModel: NSObject, ObservableObject {
    
    @Published var productFamilies = [ProductFamilyViewModel]()
    private let coreDM = CoreDataManager.shared
    
    private var fetchedResultsController: NSFetchedResultsController<ProductFamily>!
    
    func getProductFamilies() {
        
        fetchedResultsController = coreDM.requestProductFamilies()
        
        DispatchQueue.main.async {
            self.productFamilies = (self.fetchedResultsController.fetchedObjects ?? []).map(ProductFamilyViewModel.init)
        }
    }
    
    func returnProductFamilies() -> [ProductFamilyViewModel] {
        
        fetchedResultsController = coreDM.requestProductFamilies()

        return (self.fetchedResultsController.fetchedObjects ?? []).map(ProductFamilyViewModel.init)
    }
    
    func deleteProductFamilies() async throws {
        
        do {
            try await self.coreDM.deleteProductFamilyData()
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
    
    var partNumbers: Array<PartDetail> {
        return productFamily.partNumbersSorted
    }
}
