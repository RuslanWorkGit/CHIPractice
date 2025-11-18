//
//  AddContactFeature.swift
//  TCA
//
//  Created by user on 18.11.2025.
//

import ComposableArchitecture
import SwiftUI

@Reducer
struct AddContactFeature {
    
    @ObservableState
    struct State: Equatable {
        var contact: Contact
    }
    
    enum Action {
        case cancellButtonTapped
        case saveButtonTapped
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
                state.contact.name = name
                return .none
                
            }
        }
    }
}
