//
//  ProductFamilyRow.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct ProductFamilyRow: View {
    
    @EnvironmentObject var navigation : Navigation
    @State var productFamily : PartNumber
    
    var body: some View {
        NavigationLink(destination: PartNumberView(productFamily: productFamily), tag: productFamily.productFamily.description, selection: $navigation.selection) {
            Text("\(productFamily.productFamily.description)")
        }
    }
}

struct ProductFamilyRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductFamilyRow(productFamily: PartNumber() )
    }
}
