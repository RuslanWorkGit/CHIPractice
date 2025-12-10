//
//  HabitDetailFeature.swift
//  TCATest
//
//  Created by user on 08.12.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct HabitDetailFeature {

    @ObservableState
    struct State: Equatable {
        @Presents var alert: AlertState<Action.Alert>?
        var habit: Habit
    }

    enum Action {
        case toggleCompleted
        case deleteButtonTapped
        case alert(PresentationAction<Alert>)
        case delegate(Delegate)

        enum Alert {
            case confirmDeletion
        }

        enum Delegate: Equatable {
            case confirmDeletion
            case updateHabit(Habit)
        }
    }

    @Dependency(\.dismiss) var dismiss

    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .toggleCompleted:
                state.habit.isCompletedToday.toggle()
                let updated = state.habit
                return .run { send in
                    await send(.delegate(.updateHabit(updated)))
                }

            case .deleteButtonTapped:
                state.alert = .confirmDeletion
                return .none

            case .alert(.presented(.confirmDeletion)):
                return .run { send in
                    await send(.delegate(.confirmDeletion))
                    await self.dismiss()
                }

            case .alert:
                return .none

            case .delegate:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AlertState where Action == HabitDetailFeature.Action.Alert {
    static let confirmDeletion = Self {
        TextState("Delete habit?")
    } actions: {
        ButtonState(role: .destructive, action: .confirmDeletion) {
            TextState("Delete")
        }
    }
}
