//
//  PartNumberView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct PartNumberView: View {

    @State var productFamily: PartNumber
        
    var body: some View {
        
        let productName = self.productFamily.productFamily.description
        let partDetails = self.productFamily.productFamily[productName]?.sorted { $0.partNumber < $1.partNumber }

        List {
            ForEach(partDetails!) { (partDetail) in
                NavigationLink(destination: PartNumberRow(partDetail: partDetail)) {
                    Text("\(partDetail.partNumber)")
                }
            }
        }
        .navigationTitle("\(productName)")
        .navigationBarItems(trailing: HomeButtonView() )
    }
}

struct PartNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PartNumberView(productFamily: PartNumber() )
    }
}
