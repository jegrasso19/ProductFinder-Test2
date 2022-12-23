//
//  ProductFamilyJSON.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/20/22.
//

import Foundation

struct ProductFamilyJSON: Decodable {

    // Add a struct that conforms with CodingKey so we can retrieve the product family name as a key
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
    // The key is the product family name, and the value is an array of PartNumber.
    //
    private(set) var productFamilies = [ProductFamilyProperties]()
 
    init(from decoder: Decoder) throws {
        
        var rootContainer = try decoder.unkeyedContainer()
        let nestedProductFamilyContainer = try rootContainer.nestedContainer(keyedBy: JSONCodingKeys.self)
        var productFamily = try ProductFamilyProperties(from: decoder)
        
        while !rootContainer.isAtEnd {
            
            let productFamilyKey = nestedProductFamilyContainer.allKeys.first!
            
            if var partNumberArrayContainer = try? nestedProductFamilyContainer.nestedUnkeyedContainer(forKey: productFamilyKey) {
                
                var partNumbers = Array<PartNumberInfo>()
                
                while !partNumberArrayContainer.isAtEnd {
                    
                    if let partNumber = try? partNumberArrayContainer.decode(PartNumberInfo.self) {
                        partNumbers.append(partNumber)
                    }
                }
                productFamily.code = UUID().uuidString
                productFamily.name = productFamilyKey.stringValue
                productFamily.partNumbers = partNumbers
                productFamilies.append(productFamily)
            }
        }
        print(productFamilies)
    }
}
