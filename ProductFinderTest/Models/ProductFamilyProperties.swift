//
//  ProductFamilyProperties.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import Foundation

struct ProductFamilyProperties : Decodable {

    // Attributes of ProductFamily Class from CoreData
    var code: String
    var name: String
    var partNumbers: Array<PartDetailProperties>

    var dictionaryValue: [String: Any] {
        [
            "code": code,
            "name": name,
            "partNumbers": partNumbers
        ]
    }
}
