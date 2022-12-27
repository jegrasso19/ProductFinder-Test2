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
    // The key is the product family name, and the value is an array of PartDetailInfo.
    //
    private(set) var productFamilies = [ProductFamilyProperties]()
 
    init(from decoder: Decoder) throws {
        
        var rootContainer = try decoder.unkeyedContainer()
        let nestedProductFamilyContainer = try rootContainer.nestedContainer(keyedBy: JSONCodingKeys.self)
        // This is where my code fails. When decoding the JSON file, it never goes into the While loop.
        //
        var productFamily = try ProductFamilyProperties(from: decoder)
        
        while !rootContainer.isAtEnd {
            
            let productFamilyKey = nestedProductFamilyContainer.allKeys.first!
            
            if var partNumberArrayContainer = try? nestedProductFamilyContainer.nestedUnkeyedContainer(forKey: productFamilyKey) {
                
                var partNumbers = Array<PartDetailInfo>()
                
                while !partNumberArrayContainer.isAtEnd {
                    
                    if let partNumber = try? partNumberArrayContainer.decode(PartDetailInfo.self) {
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
