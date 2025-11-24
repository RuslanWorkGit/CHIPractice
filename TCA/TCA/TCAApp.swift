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
    
    static let storeTwo = Store(initialState: ContactsFeature.State()) {
        ContactsFeature()
    }
    
    var body: some Scene {
        
        WindowGroup {
            ContactsView(store: TCAApp.storeTwo)
            //CounterView(store: TCAApp.store)
        }
    }
}
