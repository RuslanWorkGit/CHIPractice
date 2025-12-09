//
//  TCATestApp.swift
//  TCATest
//
//  Created by user on 09.12.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCATestApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            CounterView(store: TCATestApp.store)
        
        }
    }
}
