//
//  PartNumber.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

//import CoreData
//import SwiftUI
//
//struct ProductFamilyJSON: Decodable {
//    
//    private(set) var productFamilies = [ProductFamilyProperties]()
//    
//    init(from decoder: Decoder) throws {
//        var rootContainer = try decoder.unkeyedContainer()
//        
//        while !rootContainer.isAtEnd {
//            if let properties = try? rootContainer.decode(ProductFamilyProperties.self) {
//                productFamilies.append(properties)
//            }
//        }
//    }
//}
//
//struct ProductFamilyProperties : Decodable {
//    
//    enum CodingKeys: String, CodingKey {
//        case productFamily
//    }
//    
//    let productFamilyId : String
//    let productFamily   : [String: [PartDetail]]
//    var partDetail      : PartDetail
//    
//    struct PartDetail : Decodable {
//        
//        enum PecKeys: String, CodingKey {
//            case partNumber
//            case orderable
//            case pnDescription
//        }
//        
//        var partNumber    : String
//        var orderable     : Bool
//        var pnDescription : String
//    }
//    
//    init(from decoder: Decoder) throws {
//        
//        let values           = try decoder.container(keyedBy: CodingKeys.self)
//        let rawProductFamily = try? values.decode([String: [PartDetail]].self, forKey: .productFamily)
//        var rawPartsList     = try values.nestedUnkeyedContainer(forKey: .productFamily)
//        
//        var partNumbers = [ProductFamilyProperties.PartDetail]()
//        self.partDetail = try ProductFamilyProperties.PartDetail(from: decoder)
//        
//        while !rawPartsList.isAtEnd {
//            
//            let rawPartNumber = try rawPartsList.nestedContainer(keyedBy: PartDetail.PecKeys.self)
//            self.partDetail.pnDescription = try rawPartNumber.decode(String.self, forKey: .partNumber)
//            
//            let rawOrderable = try rawPartsList.nestedContainer(keyedBy: PartDetail.PecKeys.self)
//            self.partDetail.orderable = try rawOrderable.decode(Bool.self, forKey: .orderable)
//            
//            let rawPnDescription = try rawPartsList.nestedContainer(keyedBy: PartDetail.PecKeys.self)
//            self.partDetail.pnDescription = try rawPnDescription.decode(String.self, forKey: .pnDescription)
//            
//            partNumbers.append(self.partDetail)
//        }
//        
//        let code  = UUID().uuidString
//        self.productFamilyId = code
//        
//        guard let productFamily = rawProductFamily
//        else {
//            throw myError.programError("Missing Data")
//        }
//        self.productFamily = productFamily
//    }
//    
//    var dictionaryValue: [String: Any] {
//        [
//            "productFamily" : [productFamily.description: [partDetailValue]]
//        ]
//    }
//    
//    var partDetailValue: [String: Any] {
//        [
//            "partNumber"    : partDetail.partNumber,
//            "orderable"     : partDetail.orderable,
//            "pnDescription" : partDetail.pnDescription
//        ]
//    }
//}
