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
//        @Presents var addContact: AddNewContactFeature.State?
//        @Presents var alert: AlertState<Action.Alert>?
        @Presents var destination: Destination.State?
        var contacts: IdentifiedArrayOf<NewContact> = []
    }
    
    enum Action {
        case addButtonTapped
//        case addContact(PresentationAction<AddNewContactFeature.Action>)
//        case alert(PresentationAction<Alert>)
        case destination(PresentationAction<Destination.Action>)
        case deleteButtonTapped(id: Contact.ID)

        enum Alert: Equatable {
            case confirmDeleetion(id: Contact.ID)
        }
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .addButtonTapped:
                //state.addContact = AddNewContactFeature.State(newContact: NewContact(id: UUID(), name: ""))
                state.destination = .addContact(AddNewContactFeature.State(newContact: NewContact(id: UUID(), name: "")))
                return .none
                
//            case let .addContact(.presented(.delegate(.saveContact(newContact)))):
//                state.contacts.append(newContact)
//                return .none
                
            case let .destination(.presented(.addContact(.delegate(.saveContact(newContact))))):
                state.contacts.append(newContact)
                return .none
                
            case let .destination(.presented(.alert(.confirmDeleetion(id: id)))):
                state.contacts.remove(id: id)
                return .none
            
            case .destination:
                return .none
                
//            case .addContact:
//                return .none
                
//            case let .alert(.presented(.confirmDeleetion(id: id))):
//                state.contacts.remove(id: id)
//                return .none
                
//            case .alert:
//                return .none
                
            case let .deleteButtonTapped(id: id):
                state.destination = .alert(AlertState(title: {
                    TextState("Are you sure?")
                }, actions: {
                    ButtonState(role: .destructive, action: .confirmDeleetion(id: id)) {
                        TextState("Delete")
                    }
                }))
//                state.alert = AlertState(title: {
//                    TextState("Are you sure?")
//                }, actions: {
//                    ButtonState(role: .destructive, action: .confirmDeleetion(id: id)) {
//                        TextState("Delete")
//                    }
//                })
                return .none
            }
        }
//        .ifLet(\.$addContact, action: \.addContact) {
//            AddNewContactFeature()
//        }
//        .ifLet(\.$alert, action: \.alert)
        .ifLet(\.$destination, action: \.destination)
    }
}

extension NewContactsFeature {
    @Reducer
    enum Destination {
        case addContact(AddNewContactFeature)
        case alert(AlertState<NewContactsFeature.Action.Alert>)
    }
}

extension NewContactsFeature.Destination.State: Equatable {}
