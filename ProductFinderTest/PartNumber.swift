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
    
    class PartDetail: NSManagedObject, Identifiable {
        @NSManaged var partNumber    : String
        @NSManaged var orderable     : Bool
        @NSManaged var pnDescription : String
    }
    
    func update(from partNumberProperties: PartNumberProperties) throws {
        
        let dictionary = partNumberProperties.dictionaryValue
        let partInfo   = partNumberProperties.pecValue
        
        guard let newCode          = dictionary["code"] as? String,
              let newProductFamily = dictionary["productFamily"] as? [String: [PartDetail]],
              let newCienaPEC      = partInfo["partNumber"] as? String,
              let newOrderable     = partInfo["orderable"] as? Bool,
              let newDescription   = partInfo["pnDescription"] as? String
        else {
            throw myError.programError("Missing Data")
        }
        let partDetail = PartDetail()
        
        code          = newCode
        productFamily = newProductFamily
        partDetail.partNumber    = newCienaPEC
        partDetail.orderable     = newOrderable
        partDetail.pnDescription = newDescription
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
        let partDetails = PartDetail()
        let viewContext = ProductProvider.preview.container.viewContext
        
        for _ in 0..<count {
            let partNumber = PartNumber(context: viewContext)
            partNumber.code           = UUID().uuidString
            partNumber.productFamily  = ["Product Family 1": [partDetails]]
            partDetails.partNumber    = "100-2400-500"
            partDetails.orderable     = true
            partDetails.pnDescription = "100-2400-500 Part Number Description"
            
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
    let productFamily : [String: [PartNumber]]
    var partInfo      : PartNumber
    
    struct PartNumber : Decodable {
        
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
        let rawProductFamily = try? values.decode([String: [PartNumber]].self, forKey: .productFamily)
        var rawPartsList     = try values.nestedUnkeyedContainer(forKey: .productFamily)
        
        var partNumbers =  [PartNumber]()
        self.partInfo = try PartNumber(from: decoder)
        
        while !rawPartsList.isAtEnd {
            
            let rawPartNumber = try rawPartsList.nestedContainer(keyedBy: PartNumber.PecKeys.self)
            self.partInfo.pnDescription = try rawPartNumber.decode(String.self, forKey: .partNumber)
            
            let rawOrderable = try rawPartsList.nestedContainer(keyedBy: PartNumber.PecKeys.self)
            self.partInfo.orderable = try rawOrderable.decode(Bool.self, forKey: .orderable)
            
            let rawPnDescription = try rawPartsList.nestedContainer(keyedBy: PartNumber.PecKeys.self)
            self.partInfo.pnDescription = try rawPnDescription.decode(String.self, forKey: .pnDescription)
            
            partNumbers.append(self.partInfo)
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
            "productFamily" : [productFamily.description: [pecValue]]
        ]
    }
    var pecValue: [String: Any] {
        [
            "partNumber"    : partInfo.partNumber,
            "orderable"     : partInfo.orderable,
            "pnDescription" : partInfo.pnDescription
        ]
    }
}
