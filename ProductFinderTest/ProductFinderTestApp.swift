//
//  ProductFinderTestApp.swift
//  ProductFinderTest
//
//  Created by Joseph Grasso on 8/1/22.
//

import SwiftUI

@main
struct ProductFinderTestApp: App {
    
    @StateObject var navigate = Navigation()
    @StateObject var coreDM = CoreDataManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigate)
                .environmentObject(CoreDataManager.shared)
                .environment(\.managedObjectContext, coreDM.viewContext)
        }
    }
}
