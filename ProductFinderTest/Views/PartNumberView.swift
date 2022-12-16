//
//  PartNumberView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct PartNumberView: View {

    @State var productFamily: ProductFamily
        
    var body: some View {
        
        Text("")        
//        let productFamilyName = productFamily.name
//        let partNumbers = productFamily.partNumbers
//
//        List {
//            ForEach(partNumbers, id: \.id) { (partNumber) in
//                NavigationLink(destination: PartNumberRow(partNumber: partNumber)) {
//                    Text("\(partNumber.partNumber)")
//                }
//            }
//        }
//        .navigationTitle("\(productFamilyName)")
//        .navigationBarItems(trailing: HomeButtonView() )
//        }
    }
}

struct PartNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PartNumberView(productFamily: ProductFamily() )
    }
}
