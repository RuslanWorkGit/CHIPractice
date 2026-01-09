//
//  HabiFeature.swift
//  TCATest
//
//  Created by user on 08.12.2025.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AddHabitFeature {

    @ObservableState
    struct State: Equatable {
        var habit: Habit
    }

    enum Action {
        case cancelButtonTapped
        case saveButtonTapped
        case setTitle(String)
        case setNotes(String)
        case delegate(Delegate)

        @CasePathable
        enum Delegate: Equatable {
            case saveHabit(Habit)
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cancelButtonTapped:
                return .run { _ in await self.dismiss() }

            case .saveButtonTapped:
                return .run { [habit = state.habit] send in
                    await send(.delegate(.saveHabit(habit)))
                    await self.dismiss()
                }

            case let .setTitle(title):
                state.habit.title = title
                return .none

            case let .setNotes(notes):
                state.habit.notes = notes
                return .none

            case .delegate:
                return .none
            }
        }
    }
}
