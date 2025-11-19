//
//  AddNewContactFeature.swift
//  TCA
//
//  Created by user on 19.11.2025.
//

import ComposableArchitecture
import Foundation

@Reducer
struct AddNewContactFeature {
    
    @ObservableState
    struct State: Equatable {
        var newContact: NewContact
    }
    
    enum Action {
        case saveButtonTapped
        case cancellButtonTapped
        case setName(String)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cancellButtonTapped:
                return .none
                
            case .saveButtonTapped:
                return .none
                
            case let .setName(name):
                state.newContact.name = name
                return .none
            }
        }
    }
}
