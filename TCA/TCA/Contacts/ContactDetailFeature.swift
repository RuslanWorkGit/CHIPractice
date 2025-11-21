//
//  ContactDetalFeature.swift
//  TCA
//
//  Created by user on 21.11.2025.
//

import ComposableArchitecture

@Reducer
struct ContactDetailFeature {
    
    @ObservableState
    struct State: Equatable {
        let contact: Contact
    }
    
    enum Action {
        
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
                
            }
        }
    }
}
