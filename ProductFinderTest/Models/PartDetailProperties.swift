//
//  PartDetailInfo.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/22/22.
//

import Foundation

// The type for decoding the PartDetail properties.
//
struct PartDetailProperties: Decodable {
    
    // Attributes of PartDetail Class from CoreData
    var partNumber   : String
    var orderable    : Bool
    var pnDescription: String
    
    var dictionaryValue: [String: Any] {
        [
            "partNumber": partNumber,
            "orderable": orderable,
            "pnDescription": pnDescription
        ]
    }
}
