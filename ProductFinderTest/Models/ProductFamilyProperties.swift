//
//  ProductFamilyProperties.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import CoreData
import SwiftUI

struct ProductFamilyProperties : Decodable {

    var code: String
    var name: String
    var partNumbers: Array<PartDetailInfo>
    
    enum CodingKeys: String, CodingKey {
        case code
        case name
        case partNumbers
    }
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let rawCode = try? values.decode(String.self, forKey: .code)
        let rawName = try? values.decode(String.self, forKey: .name)
        let rawPartNumbers = try? values.decode(Array<PartDetailInfo>.self, forKey: .partNumbers)
        
        guard let code = rawCode,
              let name = rawName,
              let partNumbers = rawPartNumbers
        else {
            throw myError.programError("Missing Data from Product Family")
        }
        
        self.code = code
        self.name = name
        self.partNumbers = partNumbers
    }

    var dictionaryValue: [String: Any] {
        [
            "code": code,
            "name": name,
            "partNumbers": partNumbers
        ]
    }
}
