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

    static let habitStore = Store(
        initialState: HabitsFeature.State(),
        reducer: { HabitsFeature() }
    )
    
    var body: some Scene {
        WindowGroup {
            //ContentView()
            HabitsView(store: Self.habitStore)
            //CounterView(store: TCATestApp.store)
        
        }
    }
}
