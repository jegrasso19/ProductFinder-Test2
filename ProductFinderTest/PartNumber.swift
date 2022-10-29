//
//  PartNumber.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import CoreData
import SwiftUI

class PartNumber: NSManagedObject {
    
    @NSManaged var code          : String
    @NSManaged var productFamily : [String: [PartDetail]]
    @NSManaged var partDetail    : PartDetail
    
    class PartDetail: NSManagedObject, Identifiable {
        @NSManaged var partNumber    : String
        @NSManaged var orderable     : Bool
        @NSManaged var pnDescription : String
    }
    
    func update(from partNumberProperties: PartNumberProperties) throws {
        
        let dictionary = partNumberProperties.dictionaryValue
        let partDetail = partNumberProperties.partDetailValue
        
        guard let newCode          = dictionary["code"] as? String,
              let newProductFamily = dictionary["productFamily"] as? [String: [PartDetail]],
              let newPartNumber    = partDetail["partNumber"] as? String,
              let newOrderable     = partDetail["orderable"] as? Bool,
              let newDescription   = partDetail["pnDescription"] as? String
        else {
            throw myError.programError("Missing Data")
        }
        let pecDetail = PartDetail()
        
        code          = newCode
        productFamily = newProductFamily
        pecDetail.partNumber    = newPartNumber
        pecDetail.orderable     = newOrderable
        pecDetail.pnDescription = newDescription
        
        productFamily[productFamily.description]?.append(pecDetail)
    }
}

extension PartNumber: Identifiable {

    static var preview: PartNumber {
        let partNumbers = PartNumber.makePreviews(count: 1)
        return partNumbers[0]
    }

    @discardableResult
    static func makePreviews(count: Int) -> [PartNumber] {
        var partNumbers = [PartNumber]()
        let partDetail = PartDetail()
        let viewContext = ProductProvider.preview.container.viewContext
        
        for _ in 0..<count {
            let partNumber = PartNumber(context: viewContext)
            partNumber.code           = UUID().uuidString
            partNumber.productFamily  = ["Product Family 1": [partDetail]]
            partDetail.partNumber    = "100-2400-500"
            partDetail.orderable     = true
            partDetail.pnDescription = "100-2400-500 Part Number Description"
            
            partNumbers.append(partNumber)
        }
        return partNumbers
    }
}

struct PartNumberJSON: Decodable {
    
    private(set) var partNumbers = [PartNumberProperties]()
    
    init(from decoder: Decoder) throws {
        var rootContainer = try decoder.unkeyedContainer()
        
        while !rootContainer.isAtEnd {
            if let properties = try? rootContainer.decode(PartNumberProperties.self) {
                partNumbers.append(properties)
            }
        }
    }
}

struct PartNumberProperties : Decodable {
    
    enum CodingKeys: String, CodingKey {
        case productFamily
    }
    let code          : String
    let productFamily : [String: [PartDetail]]
    var partDetail      : PartDetail
    
    struct PartDetail : Decodable {
        
        var partNumber    : String
        var orderable     : Bool
        var pnDescription : String
        
        enum PecKeys: String, CodingKey {
            case partNumber
            case orderable
            case pnDescription
        }
    }
    
    init(from decoder: Decoder) throws {
        let values           = try decoder.container(keyedBy: CodingKeys.self)
        let rawProductFamily = try? values.decode([String: [PartDetail]].self, forKey: .productFamily)
        var rawPartsList     = try values.nestedUnkeyedContainer(forKey: .productFamily)
        
        var partNumbers =  [PartNumberProperties.PartDetail]()
        self.partDetail = try PartNumberProperties.PartDetail(from: decoder)
        
        while !rawPartsList.isAtEnd {
            
            let rawPartNumber = try rawPartsList.nestedContainer(keyedBy: PartDetail.PecKeys.self)
            self.partDetail.pnDescription = try rawPartNumber.decode(String.self, forKey: .partNumber)
            
            let rawOrderable = try rawPartsList.nestedContainer(keyedBy: PartDetail.PecKeys.self)
            self.partDetail.orderable = try rawOrderable.decode(Bool.self, forKey: .orderable)
            
            let rawPnDescription = try rawPartsList.nestedContainer(keyedBy: PartDetail.PecKeys.self)
            self.partDetail.pnDescription = try rawPnDescription.decode(String.self, forKey: .pnDescription)
            
            partNumbers.append(self.partDetail)
        }
        let code  = UUID().uuidString
        self.code = code
        
        guard let productFamily = rawProductFamily
        else {
            throw myError.programError("Missing Data")
        }
        self.productFamily = productFamily
    }
    var dictionaryValue: [String: Any] {
        [
            "productFamily" : [productFamily.description: [partDetailValue]]
        ]
    }
    var partDetailValue: [String: Any] {
        [
            "partNumber"    : partDetail.partNumber,
            "orderable"     : partDetail.orderable,
            "pnDescription" : partDetail.pnDescription
        ]
    }
}
