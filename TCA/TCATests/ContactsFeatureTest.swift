//
//  ContactsFeatureTest.swift
//  TCA
//
//  Created by user on 20.11.2025.
//

import ComposableArchitecture
import XCTest

@testable import TCA

@MainActor
final class ContactsFeatureTests: XCTestCase {
    func testAddFlow() async {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: { uuid in
            uuid.uuid = .incrementing
        }
        
        //користувач натискає додати контакт
        await store.send(.addButtonTapped) {
            $0.destination = .addContact(
                AddContactFeature.State(contact: Contact(id: UUID(0), name: ""))
            )
        }
        
        //емуляція що користувач вводить імʼя
        await store.send(\.destination.addContact.setName, "Blov jr") {
            $0.$destination[case: \.addContact]?.contact.name = "Blov jr"
        }
        
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.receive(\.destination.addContact.delegate.saveContact, Contact(id: UUID(0), name: "Blov jr")) {
            $0.contacts = [Contact(id: UUID(0), name: "Blov jr")]
        }
        
        await store.receive(\.destination.dismiss) {
            $0.destination = nil
        }
    }
    
    func testAddFlow_NonExhaustive() async  {
        let store = TestStore(initialState: ContactsFeature.State()) {
            ContactsFeature()
        } withDependencies: {
            $0.uuid = .incrementing
        }
        
        store.exhaustivity = .off
        
        await store.send(.addButtonTapped)
        
        await store.send(\.destination.addContact.setName, "New name")
        
        await store.send(\.destination.addContact.saveButtonTapped)
        
        await store.skipReceivedActions()
        store.assert { state in
            state.contacts = [
                Contact(id: UUID(0), name: "New name")
            ]
            state.destination = nil
        }
        
    }
    
    func testDeleteContact() async {
        let store = TestStore(initialState: ContactsFeature.State(contacts: [
            Contact(id: UUID(0), name: "New one"),
            Contact(id: UUID(1), name: "New two")
        ])) {
            ContactsFeature()
        } withDependencies: { uuid in
            uuid.uuid = .incrementing
        }
        
        await store.send(.deleteButtonTapped(id: UUID(1))) {
//            $0.destination = .alert(AlertState(title: {
//                TextState("Are ypu sure?")
//            }, actions: {
//                ButtonState(role: .destructive, action: .confirmDeletion(id: UUID(1))) {
//                    TextState("Delete")
//                }
//            }))
            
            $0.destination = .alert(.deleteConfirmation(id: UUID(1)))
        }
        
        //Emulate the user confirming to delete contact by sending the confirmDeletion action in the alert
        await store.send(.destination(.presented(.alert(.confirmDeletion(id: UUID(1)))))) {
            $0.contacts.remove(id: UUID(1))
            $0.destination = nil
        }
        


    }
}
