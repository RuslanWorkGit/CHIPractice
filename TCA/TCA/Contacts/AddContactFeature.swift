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
        case delegate(Delegate)
        case saveButtonTapped
        case setName(String)
        
        @CasePathable
        enum Delegate: Equatable {
//            case cancel
            case saveContact(Contact)
        }
    }
    
    @Dependency(\.dismiss) var dismiss
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .cancellButtonTapped:
                
//                return .send(.delegate(.cancel))
                return .run { _ in await self.dismiss() }
                
            case .delegate:
                return .none
                
            case .saveButtonTapped:
                
                return .run { [contact = state.contact] send in
                    await send(.delegate(.saveContact(contact)))
                    await self.dismiss()
                    
                }
                
//                return .send(.delegate(.saveContact(state.contact)))
                
            case let .setName(name):
                state.contact.name = name
                return .none
                
            }
        }
    }
}
