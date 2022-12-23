//
//  PartNumber.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/22/22.
//

import Foundation

// The type for decoding the part number properties.
//
struct PartNumberInfo: Decodable {
    
    // Attributes of PartDetail Class
    var partNumber   : String
    var orderable    : Bool
    var pnDescription: String
    
    enum CodingKeys: String, CodingKey {
        case partNumber
        case orderable
        case pnDescription
    }
}
