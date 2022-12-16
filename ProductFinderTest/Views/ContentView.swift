//
//  ContentView.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import SwiftUI
import CoreData

enum myError: Error {
    case programError(String)
}

class Navigation: ObservableObject {
    @Published var selection : String? = nil
}

struct ContentView: View {
    
    @EnvironmentObject var navigation : Navigation
    
    var body: some View {
        NavigationView {
            VStack {
                InitialView(buttonText: "LOGIN")
            }
        }
        .environmentObject(navigation)
        .navigationViewStyle(StackNavigationViewStyle() )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(Navigation())
            .environmentObject(CoreDataManager.shared)
    }
}
