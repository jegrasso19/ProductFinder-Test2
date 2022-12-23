//
//  InitialView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct InitialView: View {
    
    @EnvironmentObject var coreDM : CoreDataManager
    @State private var navigated   : Bool = false
    @State private var dataLoaded  : Bool = false
    @State private var dataCleared : Bool = false
    
    var buttonText : String
    
    var body: some View {
        
        Button(action: {
            self.navigated.toggle()
        }, label: {
            Text("\(buttonText)")
                .bold()
                .padding()
        })
        Button(action: {
            self.dataLoaded.toggle()
            Task {
                try await self.coreDM.fetchProductData()
            }
        }, label: {
            Text("LOAD DATA")
                .bold()
                .padding()
        })
        Button(action: {
            self.dataCleared.toggle()
            Task {
//                self.coreVM.deleteProductData()
            }
        }, label: {
            Text("CLEAR DATA")
                .bold()
                .padding()
        })
        .navigationBarBackButtonHidden(true)
        NavigationLink(destination: ProductFamilyView(), isActive: $navigated ) {
            EmptyView()
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView(buttonText: "LOGIN")
    }
}
