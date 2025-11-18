//
//  CatFactClient.swift
//  TCA
//
//  Created by user on 18.11.2025.
//

import ComposableArchitecture
import Foundation

struct CatFactClient {
    var fetch: () async throws -> String
}

extension CatFactClient: DependencyKey {
    static var liveValue = Self(
        fetch: { 
            let (data, _) = try await URLSession.shared.data(from: URL(string: "https://catfact.ninja/fact")!)
            let response = try JSONDecoder().decode(CatFact.self, from: data)
            return response.fact
        }
    )
    
}

extension DependencyValues {
    var textFact: CatFactClient {
        get { self[CatFactClient.self] }
        set { self[CatFactClient.self] = newValue }
    }
}
