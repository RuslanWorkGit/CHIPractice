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
        case delegate(Delegate)
        case cancellButtonTapped
        case setName(String)
        
        enum Delegate: Equatable {
//            case cancel
            case saveContact(NewContact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cancellButtonTapped:
                return .run { _ in await self.dismiss() }
                
            case .delegate:
                return .none
                
            case .saveButtonTapped:
                
                return .run { [newContact = state.newContact] send in
                    await send(.delegate(.saveContact(newContact)))
                    await self.dismiss()
                }
                
//                return .send(.delegate(.saveContact(state.newContact)))
                
            case let .setName(name):
                state.newContact.name = name
                return .none
            }
        }
    }
}
