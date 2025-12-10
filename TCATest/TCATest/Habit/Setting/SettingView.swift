//
//  SettingView.swift
//  TCATest
//
//  Created by user on 09.12.2025.
//

import SwiftUI
import ComposableArchitecture

struct SettingsView: View {
    @Bindable var store: StoreOf<SettingsFeature>

    var body: some View {
        Form {
            Section("Reminders") {
                Toggle(
                    "Daily reminders",
                    isOn: $store.remindersEnabled.sending(\.setRemindersEnabled)
                )
            }

            Section("Goals") {
                Stepper(
                    "Habits per day: \(store.dailyGoal)",
                    value: $store.dailyGoal.sending(\.setDailyGoal),
                    in: 1...10
                )
            }
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(
        store: Store(
            initialState: SettingsFeature.State(),
            reducer: { SettingsFeature() }
        )
    )
}
