//
//  ColoredDot.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct ColoredDot: View {
    
    @State var dotColor : Color
    
    var body: some View {
        
        Circle()
            .fill(dotColor)
            .frame(width: 15, height: 15)
    }
    static func showDot(_ orderableFlag: Bool) -> ColoredDot {
        return orderableFlag ? ColoredDot(dotColor: .green) : ColoredDot(dotColor: .red)
    }
}

struct ColoredDot_Previews: PreviewProvider {
    static var previews: some View {
        ColoredDot(dotColor: .green)
    }
}
