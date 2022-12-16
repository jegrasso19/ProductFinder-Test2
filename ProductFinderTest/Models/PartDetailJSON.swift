//
//  PartDetailJSON.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 11/28/22.
//

import Foundation

struct PartDetailJSON: Decodable {

    var partNumberArray : [PartDetailProperties]
    
    // Define ProductFamilyCodingKeys type needed for creating
    // decoding container from JSONDecoder
    private struct ProductFamilyCodingKeys: CodingKey {
        
        // Use for String-keyed dictionary
        var stringValue: String
        init?(stringValue : String) {
            self.stringValue = stringValue
        }
        // Use for integer-keyed dictionary
        var intValue: Int?
        init?(intValue: Int) {
            // We are not using this, thus just return nil
            return nil
        }
    }
    
    private(set) var partDetailPropertiesList = [PartDetailProperties]()
    
    init(from decoder: Decoder) throws {
        
        // 1st step:
        // Create a decoding container using ProductFamilyCodingKeys
        // The container will contain all the JSON first level keys
        let rootContainer = try decoder.container(keyedBy: ProductFamilyCodingKeys.self)
        
        var tempArray = [PartDetailProperties]()
        
        // 2nd step:
        // Loop through each key (PartNumber ID) in container
        for key in rootContainer.allKeys {
            
            // Decode PartDtail using key & keep decoded PartDetail object in tempArray
            let decodedObject = try rootContainer.decode(PartDetailProperties.self, forKey: ProductFamilyCodingKeys(stringValue: key.stringValue)!)
            tempArray.append(decodedObject)
        }
        
        // 3rd step:
        // Finish decoding all PartNumber objects. Thus assign tempArray to partNumberArray.
        partNumberArray = tempArray
    }
}
