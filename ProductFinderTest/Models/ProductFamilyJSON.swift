//
//  ProductFamilyJSON.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/20/22.
//

import Foundation

struct ProductFamilyJSON: Decodable {

    // Struct that conforms with CodingKey so we can retrieve the product family name as a key
    //
    private struct JSONCodingKeys: CodingKey {
        var stringValue: String
        var intValue: Int?

        init?(stringValue: String) {
            self.stringValue = stringValue
        }

        init?(intValue: Int) {
            self.init(stringValue: "\(intValue)")
            self.intValue = intValue
        }
    }
    // This is the dictionary that contains the JSON data
    // The key is the ProductFamily name, and the value is an array of PartDetailInfo.
    //
    private(set) var productFamilies = [ProductFamilyProperties]()
 
    init(from decoder: Decoder) throws {

        var rootContainer = try decoder.unkeyedContainer()
        
        while !rootContainer.isAtEnd {
            
            let nestedProductFamilyContainer = try rootContainer.nestedContainer(keyedBy: JSONCodingKeys.self)
            let productFamilyKey = nestedProductFamilyContainer.allKeys.first!
            
            if var partNumberArrayContainer = try? nestedProductFamilyContainer.nestedUnkeyedContainer(forKey: productFamilyKey) {
                
                var partNumbers = Array<PartDetailProperties>()
                
                while !partNumberArrayContainer.isAtEnd {
                
                    if let partNumber = try? partNumberArrayContainer.decode(PartDetailProperties.self) {
                        partNumbers.append(partNumber)
                    }
                }
                let partNumbersSorted = partNumbers.sorted(by: { $0.partNumber < $1.partNumber })
                
                let productFamily = ProductFamilyProperties(code: UUID().uuidString,
                                                            name: productFamilyKey.stringValue,
                                                            partNumbers: partNumbersSorted)
                productFamilies.append(productFamily)
            }
        }
    }
}
