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
        
        let partNumbers = self.productFamily.partNumbers.sorted{ $0.code > $1.code }
        
        List {
            ForEach(partNumbers) { (partNumber) in
                NavigationLink(destination: PartNumberRow(partNumber: partNumber)) {
                    Text("\(partNumber.partNumber)")
                }
            }
        }
        .navigationTitle("\(productFamily.productFamily)")
        .navigationBarItems(trailing: HomeButtonView() )
    }
}

struct PartNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PartNumberView(productFamily: ProductFamily() )
    }
}
