//
//  PartDetailProperties.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 11/24/22.
//

import Foundation

/// A struct encapsulating the properties of a PartDetail.
struct PartDetailProperties : Decodable {

    // Define coding keys for decoding use
    enum CodingKeys: String, CodingKey {
        case partNumber
        case orderable
        case pnDescription
    }

    // Attributes of PartDetail
    let partNumber    : String
    let orderable     : Bool
    let pnDescription : String
    let productFamily : String
    
    // Define PartDetail ID
    let id            : String

    init(from decoder: Decoder) throws {

        let values           = try decoder.container(keyedBy: CodingKeys.self)
        let rawPartNumber    = try? values.decode(String.self, forKey: .partNumber)
        let rawOrderable     = try? values.decode(Bool.self, forKey: .orderable)
        let rawPnDescription = try? values.decode(String.self, forKey: .orderable)
        let rawProductFamily = values.codingPath.first?.stringValue
        
        // Ignore part details with missing data.
        guard let partNumber    = rawPartNumber,
              let orderable     = rawOrderable,
              let pnDescription = rawPnDescription,
              let productFamily = rawProductFamily
        else {
            let values = "partNumber = \(rawPartNumber?.description ?? "nil"), "
            + "rawOrderable = \(rawOrderable?.description ?? "nil"), "
            + "pnDescription = \(rawPnDescription?.description ?? "nil"), "
            + "productFamily = \(rawProductFamily?.description ?? "nil")"
            
            print(values)
            throw myError.programError("Missing Data")
        }
        
        self.partNumber    = partNumber
        self.orderable     = orderable
        self.pnDescription = pnDescription
        self.productFamily = productFamily
        self.id            = UUID().uuidString
    }

    // The keys must have the same name as the attributes of the PartDetail entity.
    var dictionaryValue: [String: Any] {
        [
            "partNumber"    : partNumber,
            "orderable"     : orderable,
            "pnDescription" : pnDescription,
            "productFamily" : productFamily,
            "id"            : id
        ]
    }
}
