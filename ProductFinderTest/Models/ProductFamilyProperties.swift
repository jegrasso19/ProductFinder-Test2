//
//  ProductFamilyProperties.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import CoreData
import SwiftUI

struct ProductFamilyProperties : Decodable {

    enum ProductFamilyCodingKeys: String, CodingKey {
        case code
        case name
        case partNumbers
    }
    
    var code        : String
    var name        : String
    var partNumbers : Array<PartNumberInfo>
    
    // This is the dictionary that contains the JSON data
    // The key is the product family name, and the value is an array of PartNumber.
    private(set) var productFamilies = [ProductFamilyProperties]()
    
    init(from decoder: Decoder) throws {
        
        var rootContainer   = try decoder.unkeyedContainer()
        let nestedContainer = try rootContainer.nestedContainer(keyedBy: ProductFamilyCodingKeys.self)
        var rawPartsList    = try nestedContainer.nestedUnkeyedContainer(forKey: .name)
        
        var rawProductFamily = try ProductFamilyProperties(from: decoder)
        var rawPartDetail    = try PartNumberInfo(from: decoder)
        
        var newPartsList : Array<PartNumberInfo> = []
        
        while !rawPartsList.isAtEnd {
            
            let rawPartNumber = try rawPartsList.nestedContainer(keyedBy: PartNumberInfo.CodingKeys.self)
            rawPartDetail.partNumber = try rawPartNumber.decode(String.self, forKey: .partNumber)
            
            let rawOrderable = try rawPartsList.nestedContainer(keyedBy: PartNumberInfo.CodingKeys.self)
            rawPartDetail.orderable = try rawOrderable.decode(Bool.self, forKey: .orderable)
            
            let rawPnDescription = try rawPartsList.nestedContainer(keyedBy: PartNumberInfo.CodingKeys.self)
            rawPartDetail.pnDescription = try rawPnDescription.decode(String.self, forKey: .pnDescription)
            
            newPartsList.append(rawPartDetail)
        }
        rawProductFamily.code = UUID().uuidString
        rawProductFamily.name = nestedContainer.codingPath.description
        rawProductFamily.partNumbers = newPartsList
        
        productFamilies.append(rawProductFamily)
        
        self.code        = rawProductFamily.code
        self.name        = rawProductFamily.name
        self.partNumbers = rawProductFamily.partNumbers
    }

    var dictionaryValue: [String: Any] {
        [
            "code       " : code,
            "name"        : name,
            "partNumbers" : partNumbers
        ]
    }
}
