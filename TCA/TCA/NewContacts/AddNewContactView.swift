//
//  AddNewContactView.swift
//  TCA
//
//  Created by user on 19.11.2025.
//
import ComposableArchitecture
import SwiftUI


struct AddNewContactView: View {
    
    @Bindable var store: StoreOf<AddNewContactFeature>
    
    var body: some View {
        
        Form {
            TextField("Name", text: $store.newContact.name.sending(\.setName))
            
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
    AddNewContactView(store: Store(initialState: AddNewContactFeature.State(newContact: NewContact(id: UUID(), name: "New")), reducer: {
        AddNewContactFeature()
    }))
}
