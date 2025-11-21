//
//  ContactDetailView.swift
//  TCA
//
//  Created by user on 21.11.2025.
//

import SwiftUI
import ComposableArchitecture

struct ContactDetailView: View {
    let store: StoreOf<ContactDetailFeature>
    
    var body: some View {
        Form {
            
        }
        .navigationTitle(store.state.contact.name)
    }
}

#Preview {
    ContactDetailView(store: Store(initialState: ContactDetailFeature.State(contact: Contact(id: UUID(), name: "Ruslan")), reducer: {
        ContactDetailFeature()
    }))
}
