//
//  HomeButtonView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct HomeButtonView: View {
    
    @EnvironmentObject var navigation : Navigation
    
    var body: some View {
        
        Button(action: {
            self.navigation.selection = nil
        }, label: {
            Image(systemName: "house")
        })
        .environmentObject(navigation)
    }
}

struct HomeButtonView_Previews: PreviewProvider {
    static var previews: some View {
        HomeButtonView()
    }
}
