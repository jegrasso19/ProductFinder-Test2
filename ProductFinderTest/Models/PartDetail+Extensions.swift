//
//  PartDetail+Extensions.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/10/22.
//

import Foundation
import CoreData

extension PartDetail {
    
    func getPartNumbersByProductFamily(productFamily: String) -> [PartDetail] {
        
        var viewContext: NSManagedObjectContext {
            return CoreDataManager.shared.viewContext
        }
        let request: NSFetchRequest<PartDetail> = PartDetail.fetchRequest()
        request.predicate = NSPredicate(format: "partDetail.productFamily == %@", productFamily)
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
}
