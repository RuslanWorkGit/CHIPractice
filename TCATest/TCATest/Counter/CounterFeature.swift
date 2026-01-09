//
//  CounterFeature.swift
//  TCATest
//
//  Created by user on 09.12.2025.
//

import ComposableArchitecture

@Reducer
struct CounterFeature {
    @ObservableState
    struct State {
        var count = 0
    }
    
    enum Action {
        case decrementButtonTapped
        case incrementButtonTapped
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                case .decrementButtonTapped:
                state.count -= 1
                return .none
                
                case .incrementButtonTapped:
                state.count += 1
                return .none
        }
        }
    }
}
