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

    func getProductFamilies() {
        productFamilyListVM.getProductFamilies()
    }
    
    var body: some View {
        List {
            ForEach(productFamilyListVM.productFamilies, id: \.objectId) { (productFamily) in
                ProductFamilyRow(productFamily: productFamily)
            }
        }
        .navigationTitle("Product Families")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .searchable(text: $searchText, placement: .navigationBarDrawer(displayMode: .always))
        .onAppear(perform: { getProductFamilies() })
        .onChange(of: searchText) { searchText in
            if !searchText.isEmpty {
                productFamilyListVM.productFamilies = productFamilyListVM.productFamilies.filter( { $0.name.contains(searchText) })
            } else {
                productFamilyListVM.getProductFamilies()
            }
        }
    }
}

struct ProductFamilyView_Previews: PreviewProvider {
    static var previews: some View {
        ProductFamilyView()
    }
}
