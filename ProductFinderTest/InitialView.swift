//
//  InitialView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 10/12/22.
//

import SwiftUI

struct InitialView: View {
    
    @EnvironmentObject var productProvider : ProductProvider
    @State private var navigated   : Bool = false
    @State private var dataLoaded  : Bool = false
    @State private var dataCleared : Bool = false
    @State private var productFamilySelection : Set<String> = []
    @State private var partNumberSelection    : Set<String> = []
    
    var buttonText : String
    
    @FetchRequest(sortDescriptors: [SortDescriptor(\.productFamily, order: .forward)])
    private var productFamilies: FetchedResults<ProductFamily>
    @FetchRequest(sortDescriptors: [SortDescriptor(\.partNumber, order: .forward)])
    private var partNumbers: FetchedResults<PartNumber>
    
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
                productFamilySelection = Set(productFamilies.map { $0.code })
                partNumberSelection    = Set(partNumbers.map { $0.code })

                await deleteProductFamilies(for: productFamilySelection)
                await deletePartNumbers(for: partNumberSelection)
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
            try await productProvider.fetchProductData()
        } catch {
            print(myError.programError("Fetch Product Data Error"))
        }
    }
    private func deleteProductFamilies(for codes: Set<String>) async {

        do {
            let productFamiliesToDelete = productFamilies.filter { codes.contains($0.code) }
            try await productProvider.deleteProductFamilies(productFamiliesToDelete)
        } catch {
            print(myError.programError("Delete ProductFamily Error"))
        }
    }
    private func deletePartNumbers(for codes: Set<String>) async {

        do {
            let partNumbersToDelete = partNumbers.filter { codes.contains($0.code) }
            try await productProvider.deletePartNumbers(partNumbersToDelete)
        } catch {
            print(myError.programError("Delete PartNumber Error"))
        }
    }
}

struct InitialView_Previews: PreviewProvider {
    static var previews: some View {
        InitialView(buttonText: "LOGIN")
    }
}
