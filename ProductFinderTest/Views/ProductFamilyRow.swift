//
//  ProductFamilyRow.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct ProductFamilyRow: View {
    
    @EnvironmentObject var navigation : Navigation
    @State var productFamily : ProductFamilyViewModel
    
    var body: some View {
        NavigationLink(destination: PartNumberView(productFamily: productFamily), tag: productFamily.name, selection: $navigation.selection) {
            Text("\(productFamily.name)")
        }
    }
}

struct ProductFamilyRow_Previews: PreviewProvider {
    static var previews: some View {
        ProductFamilyRow(productFamily: ProductFamilyViewModel(productFamily: ProductFamily()) )
    }
}
