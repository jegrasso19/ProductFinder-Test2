//
//  InitialView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct InitialView: View {
    
    @EnvironmentObject var coreDM : CoreDataManager
    @StateObject private var productFamilyListVM = ProductFamilyListViewModel()
    @State private var navigated   : Bool = false
    @State private var dataLoaded  : Bool = false
    @State private var dataCleared : Bool = false
    @State private var partNumberSelection : Set<String> = []
    
    var buttonText : String

    //@FetchRequest(sortDescriptors: [SortDescriptor(\.productFamily.description, order: .forward)])
    
    //private var productFamilies = 
    
    var body: some View {
        
        //var productFamilies = productFamilyListVM.getAllProductFamilies()
        
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
                await self.fetchProductData()
            }
        }, label: {
            Text("LOAD DATA")
                .bold()
                .padding()
        })
        Button(action: {
            self.dataCleared.toggle()
            Task {
//                partNumberSelection = Set(partNumbers.map { $0.code })
//                await deletePartNumbers(for: partNumberSelection)
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
    
    private func fetchProductData() async {

        do {
            try await coreDM.fetchProductData()
        } catch {
            print(myError.programError("Fetch Product Data Error"))
        }
    }
    
//    private func deletePartNumbers(for codes: Set<String>) async {
//
//        do {
//            let partNumbersToDelete = partNumbers.filter { codes.contains($0.code) }
//            try await coreDM.deletePartNumbers(partNumbersToDelete)
//        } catch {
//            print(myError.programError("Delete PartNumber Error"))
//        }
//    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView(buttonText: "LOGIN")
    }
}
