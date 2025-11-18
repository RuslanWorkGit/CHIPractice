//
//  AddContactView.swift
//  TCA
//
//  Created by user on 18.11.2025.
//

import SwiftUI
import ComposableArchitecture

struct AddContactView: View {
    @Bindable var store: StoreOf<AddContactFeature>
    
    var body: some View {
        Form {
            TextField("Name", text: $store.contact.name.sending(\.setName))
        
            Button("Save") {
                store.send(.saveButtonTapped)
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Cancel") {
                    store.send(.cancellButtonTapped)
                    
                }
            }
        }
    }
}


#Preview {
    AddContactView(store: Store(initialState: AddContactFeature.State(contact: Contact(id: UUID(), name: "Bloov")),
                                reducer: {
        
        AddContactFeature()
    }))
}
