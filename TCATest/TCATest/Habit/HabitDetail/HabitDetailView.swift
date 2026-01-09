//
//  HabitDetailView.swift
//  TCATest
//
//  Created by user on 08.12.2025.
//

import SwiftUI
import ComposableArchitecture

struct HabitDetailView: View {
    @Bindable var store: StoreOf<HabitDetailFeature>

    var body: some View {
        Form {
            Section {
                Toggle(
                    "Completed today",
                    isOn: Binding(
                        get: { store.habit.isCompletedToday },
                        set: { _ in store.send(.toggleCompleted) }
                    )
                )
            }

            if !store.habit.notes.isEmpty {
                Section("Notes") {
                    Text(store.habit.notes)
                }
            }

            Section {
                Button(role: .destructive) {
                    store.send(.deleteButtonTapped)
                } label: {
                    Text("Delete habit")
                }
            }
        }
        .navigationTitle(store.habit.title)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    HabitDetailView(
        store: Store(
            initialState: HabitDetailFeature.State(
                habit: Habit(
                    id: UUID(),
                    title: "Morning run",
                    notes: "2–3 km around the block",
                    isCompletedToday: false
                )
            ),
            reducer: { HabitDetailFeature() }
        )
    )
}
