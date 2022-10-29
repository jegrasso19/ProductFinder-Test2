//
//  PartNumberRow.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct PartNumberRow: View {
    
    @State var partDetail : PartNumber.PartDetail
    
    var body: some View {
        List {
            Text("Product Family: \(partDetail.partNumber)")
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
        PartNumberRow(partDetail: PartNumber.PartDetail() )
    }
}
