//
//  PartDetailInfo.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 12/22/22.
//

import Foundation

// The type for decoding the PartDetail properties.
//
struct PartDetailInfo: Decodable {
    
    // Attributes of PartDetail Class from CoreData
    var code         : String
    var partNumber   : String
    var orderable    : Bool
    var pnDescription: String
    
    enum CodingKeys: String, CodingKey {
        case code
        case partNumber
        case orderable
        case pnDescription
    }
}
