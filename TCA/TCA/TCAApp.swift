//
//  TCAApp.swift
//  TCA
//
//  Created by user on 13.11.2025.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAApp: App {
    static let store = Store(initialState: CounterFeature.State()) {
        CounterFeature()
            ._printChanges()
    }
    
    var body: some Scene {
        WindowGroup {
            CounterView(store: TCAApp.store)
        }
    }
}
