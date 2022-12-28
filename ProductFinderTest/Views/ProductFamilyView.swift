//
//  ProductFamilyView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct ProductFamilyView: View { //This is my home view


    @StateObject private var productFamilyListVM = ProductFamilyListViewModel()
    @State private var searchText : String = ""
    
    var productFamilies: [ProductFamilyViewModel] {
        productFamilyListVM.returnProductFamilies()
    }
        
//    var query: Binding<String> {
//        Binding {
//            searchText
//        } set: { newValue in
//            searchText = newValue
//            productFamilyListVM.productFamilies.nsPredicate = newValue.isEmpty ? nil : NSPredicate(format: "name CONTAINS %@", newValue.uppercased())
//        }
//    }
    
    var body: some View {
        List {
            ForEach(productFamilies, id: \.code) { (productFamily) in
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
