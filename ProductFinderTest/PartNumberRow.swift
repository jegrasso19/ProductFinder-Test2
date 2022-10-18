//
//  PartNumberRow.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct PartNumberRow: View {
    
    @State var partNumber : PartNumber
    
    var body: some View {
        List {
            Text("Product Family: \(partNumber.productFamily)")
            Text("Description: \(partNumber.pnDescription)")
            HStack {
                Text("Orderable: ")
                ColoredDot.showDot(partNumber.orderable)
            }
        }
        .navigationTitle("\(partNumber.partNumber)")
        .navigationBarItems(trailing: HomeButtonView() )
    }
}

struct PartNumberRow_Previews: PreviewProvider {
    static var previews: some View {
        PartNumberRow(partNumber: PartNumber() )
    }
}
