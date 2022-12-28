//
//  PartNumberView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct PartNumberView: View {

    @State var productFamily: ProductFamilyViewModel
        
    var body: some View {
                
        let partNumbers = (self.productFamily.partNumbers.allObjects as! [PartDetail]).sorted(by: { $0.code < $1.code })
        
        List {
            ForEach(partNumbers, id: \.code) { (partNumber) in
                NavigationLink(destination: PartNumberRow(partDetail: partNumber)) {
                    Text("\(partNumber.partNumber)")
                }
            }
        }
        .navigationTitle("\(productFamily.name)")
        .navigationBarItems(trailing: HomeButtonView() )
    }
}

struct PartNumberView_Previews: PreviewProvider {
    static var previews: some View {
        PartNumberView(productFamily: ProductFamilyViewModel(productFamily: ProductFamily()) )
    }
}
