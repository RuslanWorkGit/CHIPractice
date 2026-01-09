//
//  AddHabitView.swift
//  TCATest
//
//  Created by user on 08.12.2025.
//

import SwiftUI
import ComposableArchitecture

struct AddHabitView: View {
    @Bindable var store: StoreOf<AddHabitFeature>

    var body: some View {
        Form {
            Section("Basic info") {
                TextField(
                    "Title",
                    text: $store.habit.title.sending(\.setTitle)
                )

                TextField(
                    "Notes",
                    text: $store.habit.notes.sending(\.setNotes)
                )
            }

            Button("Save") {
                store.send(.saveButtonTapped)
            }
        }
        .navigationTitle("New habit")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    store.send(.cancelButtonTapped)
                }
            }
        }
    }
}

#Preview {
    AddHabitView(
        store: Store(
            initialState: AddHabitFeature.State(
                habit: Habit(
                    id: UUID(),
                    title: "Read 20 pages",
                    notes: "Evening reading before sleep",
                    isCompletedToday: false
                )
            ),
            reducer: { AddHabitFeature() }
        )
    )
}
