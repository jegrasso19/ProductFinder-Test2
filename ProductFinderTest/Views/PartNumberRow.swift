//
//  PartNumberRow.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct PartNumberRow: View {
    
    @State var partDetail : PartDetail
    
    var body: some View {
        List {
            Text("Product Family: \(partDetail.productFamily.name)")
            Text("Description: \(partDetail.pnDescription)")
            HStack {
                Text("Orderable: ")
                ColoredDot.showDot(partDetail.orderable)
            }
        }
        .navigationTitle("\(partDetail.partNumber)")
        .navigationBarItems(trailing: HomeButtonView() )
    }
}

struct PartNumberRow_Previews: PreviewProvider {
    static var previews: some View {
        PartNumberRow(partDetail: PartDetail() )
    }
}
