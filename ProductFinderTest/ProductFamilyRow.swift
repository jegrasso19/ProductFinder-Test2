//
//  ProductFamilyRow.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct ProductFamilyRow: View {
    
    @EnvironmentObject var navigation : Navigation
    @State var productFamily : ProductFamily

    var body: some View {
        NavigationLink(destination: PartNumberView(productFamily: productFamily), tag: productFamily.productFamily, selection: $navigation.selection) {
            Text("\(productFamily.productFamily)")
        }
    }
}

struct ProductFamilyRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductFamilyRow(productFamily: ProductFamily() )
    }
}
