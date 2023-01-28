//
//  PartDetail+CoreDataProperties.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/26/22.
//
//

import Foundation
import CoreData


extension PartDetail {

    @nonobjc public class func fetchPartDetailRequest() -> NSFetchRequest<PartDetail> {
        return NSFetchRequest<PartDetail>(entityName: "PartDetail")
    }

    @NSManaged public var orderable: Bool
    @NSManaged public var partNumber: String
    @NSManaged public var pnDescription: String
    @NSManaged public var productFamilyName: String
    @NSManaged public var productFamily: ProductFamily
}

extension PartDetail : Identifiable {

}
