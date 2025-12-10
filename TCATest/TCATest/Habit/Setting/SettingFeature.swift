//
//  SettingFeature.swift
//  TCATest
//
//  Created by user on 09.12.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct SettingsFeature {

    @ObservableState
    struct State: Equatable {
        var remindersEnabled = true
        var dailyGoal = 3
    }

    enum Action {
        case setRemindersEnabled(Bool)
        case setDailyGoal(Int)
    }

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .setRemindersEnabled(isOn):
                state.remindersEnabled = isOn
                return .none

            case let .setDailyGoal(goal):
                state.dailyGoal = goal
                return .none
            }
        }
    }
}
