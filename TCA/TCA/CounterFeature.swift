//
//  CounterFeature.swift
//  TCA
//
//  Created by user on 13.11.2025.
//

import ComposableArchitecture
import SwiftUI

struct CatFact: Decodable, Equatable {
    let fact: String
    let length: Int
}

@Reducer
struct CounterFeature {
    
    @ObservableState
    struct State: Equatable {
        var count = 0
        var fact: String?
        var isLoading = false
        var isTimerRunning = false
    }
    
    enum Action: Equatable {
        case decrementButtonTapped
        case factButtonTapped
        case factResponse(String)
        case incrementButtonTapped
        case timerTick
        case toggleTimerButtonTapped
    }
    
    nonisolated enum CancelID { case timer }
    
    var body: some Reducer<State, Action>  {
        Reduce { state, action in
            switch action {
            case .decrementButtonTapped:
                state.count -= 1
                state.fact = nil
                return .none
                
            case .factButtonTapped:
                state.fact = nil
                state.isLoading = true
                return .run { send in
                    let url = URL(string: "https://catfact.ninja/fact")!
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let response = try JSONDecoder().decode(CatFact.self, from: data)
                    await send(.factResponse(response.fact))
                } catch: { error, send in
                    await send(.factResponse(error.localizedDescription))
                }
                
            case let .factResponse(fact):
                state.fact = fact
                state.isLoading = false
                return .none
                
            case .incrementButtonTapped:
                state.count += 1
                state.fact = nil
                return .none
                
            case .timerTick:
                state.count += 1
                state.fact = nil
                return .none
                
            case .toggleTimerButtonTapped:
                state.isTimerRunning.toggle()
                if state.isTimerRunning {
                    return .run { send in
                        while true {
                            try await Task.sleep(for: .seconds(1))
                            await send(.timerTick)
                        }
                    }
                    .cancellable(id: CancelID.timer)
                } else {
                    return .cancel(id: CancelID.timer)
                }
            }
        }
    }
}

