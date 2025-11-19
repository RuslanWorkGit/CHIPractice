//
//  NewContactsView.swift
//  TCA
//
//  Created by user on 19.11.2025.
//

import SwiftUI
import ComposableArchitecture

struct NewContactsView: View {
    @Bindable var store: StoreOf<NewContactsFeature>
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(store.contacts) { contact in
                    Text(contact.name)
                }
            }
            .navigationTitle("NewContacts")
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
        .sheet(item: $store.scope(state: \.addContact, action: \.addContact)) { addNewContactStore in
            AddNewContactView(store: addNewContactStore)
        }
    }
}

#Preview {
    NewContactsView(store: Store(initialState: NewContactsFeature.State(contacts: [
        NewContact(id: UUID(), name: "Ruslan"),
        NewContact(id: UUID(), name: "MKsksk"),
        NewContact(id: UUID(), name: "Yana"),
        NewContact(id: UUID(), name: "Niowo")
    ]), reducer: {
        NewContactsFeature()
    }))
}
