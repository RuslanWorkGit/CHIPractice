//
//  HabitsView.swift
//  TCATest
//
//  Created by user on 09.12.2025.
//

import SwiftUI
import ComposableArchitecture

struct HabitsView: View {
    @Bindable var store: StoreOf<HabitsFeature>
    
    var body: some View {
        NavigationStack(
            path: $store.scope(state: \.path, action: \.path)
        ) {
            List {
                if store.habits.isEmpty {
                    ContentUnavailableView(
                        "No habits yet",
                        systemImage: "list.bullet",
                        description: Text("Tap + to create your first habit.")
                    )
                } else {
                    ForEach(store.habits) { habit in
                        Button {
                            store.send(.habitTapped(id: habit.id))
                        } label: {
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(habit.title)
                                        .font(.headline)
                                    if !habit.notes.isEmpty {
                                        Text(habit.notes)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                            .lineLimit(1)
                                    }
                                }
                                Spacer()
                                Image(
                                    systemName: habit.isCompletedToday
                                    ? "checkmark.circle.fill"
                                    : "circle"
                                )
                                .foregroundColor(habit.isCompletedToday ? .green : .gray)
                            }
                        }
                    }
                    .onDelete { indexSet in
                        store.send(.deleteHabit(indexSet))
                    }
                }
                
                Section("Cat facts") {
                    Button {
                        store.send(.catFactButtonTapped)
                    } label: {
                        HStack {
                            Text("Get cat fact")
                            if store.isCatFactLoading {
                                Spacer()
                                ProgressView()
                            }
                        }
                    }
                    
                    ForEach(
                        Array(store.catFacts.enumerated()),
                        id: \.offset
                    ) { _, fact in
                        Text(fact)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                            .padding(.vertical, 4)
                    }
                }
                
            }
            .navigationTitle("Habits")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        store.send(.settingsButtonTapped)
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } destination: { pathStore in
            switch pathStore.case {
            case .habitDetail(let habitDetailStore):
                HabitDetailView(store: habitDetailStore)
                
            case .settings(let settingsStore):
                SettingsView(store: settingsStore)
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
        .sheet(
            item: $store.scope(
                state: \.destination?.addHabit,
                action: \.destination.addHabit
            )
        ) { addHabitStore in
            NavigationStack {
                AddHabitView(store: addHabitStore)
            }
        }
    }
}

#Preview {
    HabitsView(
        store: Store(
            initialState: HabitsFeature.State(
                habits: [
                    Habit(
                        id: UUID(),
                        title: "Drink water",
                        notes: "At least 6 glasses",
                        isCompletedToday: false
                    ),
                    Habit(
                        id: UUID(),
                        title: "Learn Swift",
                        notes: "30 minutes of TCA practice",
                        isCompletedToday: true
                    )
                ]
            ),
            reducer: { HabitsFeature() }
        )
    )
}
