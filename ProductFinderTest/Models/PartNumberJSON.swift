//
//  PartNumberJSON.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/10/22.
//

import Foundation

struct PartNumberJSON: Decodable {
    
    private enum PartNumberCodingKeys: String, CodingKey {
        case partNumber
        case orderable
        case pnDescription
    }
    
    private(set) var partNumberPropertiesList: [PartDetailProperties] = []
    
    init(from decoder: Decoder) throws {
        var rootContainer = try decoder.unkeyedContainer()
        
        while !rootContainer.isAtEnd {
            
            let partNumbersContainer = try rootContainer.nestedContainer(keyedBy: PartNumberCodingKeys.self)

            if let properties = try? partNumbersContainer.decode(PartDetailProperties.self, forKey: .partNumber) {
                partNumberPropertiesList.append(properties)
            }
        }
        
    }
}
