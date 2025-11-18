//
//  ContactsFeature.swift
//  TCA
//
//  Created by user on 18.11.2025.
//

import Foundation
import ComposableArchitecture

struct Contact: Equatable, Identifiable {
    let id: UUID
    var name: String
}

@Reducer
struct ContactsFeature {
    
    @ObservableState
    struct State: Equatable {
        @Presents var addContact: AddContactFeature.State?
        var contacts: IdentifiedArrayOf<Contact> = []
    }
    
    enum Action {
        case addButtonTapped
        case addContact(PresentationAction<AddContactFeature.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                state.addContact = AddContactFeature.State(contact: Contact(id: UUID(), name: ""))
                
                return .none
                
            case .addContact(.presented(.cancellButtonTapped)):
                state.addContact = nil
                return .none
                
            case .addContact(.presented(.saveButtonTapped)):
                guard let contact = state.addContact?.contact else {
                    return .none
                }
                
                state.contacts.append(contact)
                state.addContact = nil
                return .none

            case .addContact:
                //state.contacts.append(contact)
                return .none
                                    
            }
        }
        .ifLet(\.$addContact, action: \.addContact) {
            AddContactFeature()
        }
    }
}
