//
//  ContactsView.swift
//  TCA
//
//  Created by user on 18.11.2025.
//

import SwiftUI
import ComposableArchitecture

struct ContactsView: View {
    
    //let store: StoreOf<ContactsFeature>
    @Bindable var store: StoreOf<ContactsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    Text(contact.name)
                }
            }
            .navigationTitle("Contacts")
            .toolbar {
                ToolbarItem {
                    Button {
                        store.send(.addButtonTapped)
                    } label: {
                        Image(systemName: "plus")
                    }

                }
            }
        }
        .sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { addContactStore in
            NavigationStack {
                AddContactView(store: addContactStore)
            }
        }
    }
}

#Preview {
    ContactsView(store: Store(initialState: ContactsFeature.State(contacts: [
        Contact(id: UUID(), name: "Blob"),
        Contact(id: UUID(), name: "Blob New"),
        Contact(id: UUID(), name: "Blob OLD")
    ]), reducer: {
        ContactsFeature()
    }))
}
