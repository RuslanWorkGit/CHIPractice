//
//  HabitsFeature.swift
//  TCATest
//
//  Created by user on 09.12.2025.
//

import Foundation
import ComposableArchitecture

@Reducer
struct HabitsFeature {
    
    // MARK: - State
    
    @Reducer
    enum Path {
        case habitDetail(HabitDetailFeature)
        case settings(SettingsFeature)
    }
    
    // MARK: - Destination (sheet’и / модальні)
    @Reducer
    enum Destination {
        case addHabit(AddHabitFeature)
    }
    
    @ObservableState
    struct State: Equatable {
        var habits: IdentifiedArrayOf<Habit> = []
        var path = StackState<Path.State>()
        @Presents var destination: Destination.State?
        
        var catFacts: [String] = []
        var isCatFactLoading = false
    }
    
    // MARK: - Action
    
    enum Action {
        case addButtonTapped
        case habitTapped(id: Habit.ID)
        case settingsButtonTapped
        case deleteHabit(IndexSet)
        case onAppear
        case habitsLoaded([Habit])
        case catFactButtonTapped
        case catFactResponse(String)
        
        case destination(PresentationAction<Destination.Action>)
        case path(StackAction<Path.State, Path.Action>)
    }
    
    // MARK: - Dependencies
    
    @Dependency(\.uuid) var uuid
    @Dependency(\.textFact) var textFact
    @Dependency(\.habitStorage) var habitStorage
    // MARK: - Body
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            case .onAppear:
                return .run { send in
                    let habits = (try? self.habitStorage.load()) ?? []
                    await send(.habitsLoaded(habits))
                }
                
            case let .habitsLoaded(habits):
                state.habits = IdentifiedArray(uniqueElements: habits)
                return .none
                
            case .addButtonTapped:
                state.destination = .addHabit(
                    AddHabitFeature.State(
                        habit: Habit(
                            id: uuid(),
                            title: "",
                            notes: "",
                            isCompletedToday: false
                        )
                    )
                )
                return .none
                
            case let .destination(.presented(.addHabit(.delegate(.saveHabit(habit))))):
                state.habits.append(habit)
                let habits = state.habits
                return .run { _ in
                    try? self.habitStorage.save(Array(habits))
                }
                return .none
                
            case .destination:
                return .none
                
            case let .habitTapped(id):
                guard let habit = state.habits[id: id] else { return .none }
                state.path.append(
                    .habitDetail(
                        HabitDetailFeature.State(habit: habit)
                    )
                )
                return .none
                
            case .settingsButtonTapped:
                state.path.append(
                    .settings(
                        SettingsFeature.State()
                    )
                )
                return .none
                
            case let .deleteHabit(indexSet):
                state.habits.remove(atOffsets: indexSet)
                return .none
                
            case .catFactButtonTapped:
                state.isCatFactLoading = true
                return .run { send in
                    let fact = try await self.textFact.fetch()
                    await send(.catFactResponse(fact))
                }
                
            case let .catFactResponse(fact):
                state.isCatFactLoading = false
                state.catFacts.append(fact)
                return .none
                
                // Отримали delegate з HabitDetailFeature: видалити
            case let .path(.element(id: pathID, action: .habitDetail(.delegate(.confirmDeletion)))):
                guard case let .habitDetail(detailState) = state.path[id: pathID] else {
                    return .none
                }
                state.habits.remove(id: detailState.habit.id)
                return .none
                
                // Delegate з HabitDetailFeature: оновити
            case let .path(.element(_, action: .habitDetail(.delegate(.updateHabit(updated))))):
                if let index = state.habits.firstIndex(where: { $0.id == updated.id }) {
                    state.habits[index] = updated
                }
                return .none
                
            case .path:
                return .none
            }
        }
        .ifLet(\.$destination, action: \.destination)
        .forEach(\.path, action: \.path)
    }
}

// Як у ContactsFeature ти окремо робив Equatable для Destination.State.:contentReference[oaicite:7]{index=7}
extension HabitsFeature.Destination.State: Equatable {}
extension HabitsFeature.Path.State: Equatable {}
