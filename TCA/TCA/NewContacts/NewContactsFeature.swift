//
//  NewContactsFeature.swift
//  TCA
//
//  Created by user on 19.11.2025.
//
import ComposableArchitecture
import SwiftUI

struct NewContact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct NewContactsFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddNewContactFeature.State?
        var contacts: IdentifiedArrayOf<NewContact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddNewContactFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddNewContactFeature.State(newContact: NewContact(id: UUID(), name: ""))
                return .none
            case .addContact(.presented(.saveButtonTapped)):
                guard let newContact = state.addContact?.newContact else {
                    return .none
                }
                state.contacts.append(newContact)
                state.addContact = nil
                return .none
                
            case .addContact(.presented(.cancellButtonTapped)):
                state.addContact = nil
                return .none
                
            case .addContact:
                
                return .none
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddNewContactFeature()
        }
    }
}

