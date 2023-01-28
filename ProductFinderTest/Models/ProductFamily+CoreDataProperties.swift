//
//  ProductFamily+CoreDataProperties.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/26/22.
//
//

import Foundation
import CoreData


extension ProductFamily {

    @nonobjc public class func fetchProductFamilyRequest() -> NSFetchRequest<ProductFamily> {
        return NSFetchRequest<ProductFamily>(entityName: "ProductFamily")
    }

    @NSManaged public var code: String
    @NSManaged public var name: String
    @NSManaged public var partNumbers: Set<PartDetail>
}

// MARK: Generated accessors for partNumbers
extension ProductFamily {
    
    @objc(addPartNumbersObject:)
    @NSManaged public func addToPartNumbers(_ value: PartDetail)
    
    @objc(removePartNumbersObject:)
    @NSManaged public func removeFromPartNumbers(_ value: PartDetail)
    
    @objc(addPartNumbers:)
    @NSManaged public func addToPartNumbers(_ values: Set<PartDetail>)
    
    @objc(removePartNumbers:)
    @NSManaged public func removeFromPartNumbers(_ values: Set<PartDetail>)
    
    public var partNumbersSorted: Array<PartDetail> {
        return partNumbers.sorted {
            $0.partNumber < $1.partNumber
        }
    }

}

extension ProductFamily : Identifiable {

}
