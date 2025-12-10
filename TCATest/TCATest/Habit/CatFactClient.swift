//
//  CatFactClient.swift
//  TCATest
//
//  Created by user on 10.12.2025.
//

import ComposableArchitecture
import Foundation

struct CatFact: Decodable, Equatable {
    let fact: String
    let length: Int
}


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
