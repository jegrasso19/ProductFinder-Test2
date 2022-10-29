//
//  ProductFamilyView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct ProductFamilyView: View { //This is my home view

    @State private var searchText : String = ""
    @FetchRequest(sortDescriptors: [SortDescriptor(\.productFamily.description, order: .forward)])
    var productFamilies : FetchedResults<PartNumber>
    
    var query: Binding<String> {
        Binding {
            searchText
        } set: { newValue in
            searchText = newValue
            productFamilies.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "productFamily CONTAINS %@", newValue.uppercased())
        }
    }
    var body: some View {
        List {
            ForEach(productFamilies) { (productFamily) in
                ProductFamilyRow(productFamily: productFamily)
            }
        }
        .navigationTitle("Product Families")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
    }
}

struct ProductFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        ProductFamilyView()
    }
}
