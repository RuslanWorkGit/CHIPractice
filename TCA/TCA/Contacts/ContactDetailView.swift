//
//  ContactDetailView.swift
//  TCA
//
//  Created by user on 21.11.2025.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    @Bindable var store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        Form {
            Button("Delete") {
                store.send(.deleteButtonTapped)
            }
        }
        .navigationTitle(store.state.contact.name)
        .alert($store.scope(state: \.alert, action: \.alert))
    }
}

#Preview {
    ContactDetailView(store: Store(initialState: ContactDetailFeature.State(contact: Contact(id: UUID(), name: "Ruslan")), reducer: {
        ContactDetailFeature()
    }))
}
