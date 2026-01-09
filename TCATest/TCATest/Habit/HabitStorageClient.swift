//
//  HabitStorageClient.swift
//  TCATest
//
//  Created by user on 10.12.2025.
//

import Foundation
import ComposableArchitecture

struct HabitStorageClient {
    var load: () throws -> [Habit]
    var save: ([Habit]) throws -> Void
}

extension HabitStorageClient: DependencyKey {
    static var liveValue: Self = {
        let url = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("habits.json")

        return Self(
            load: {
                guard FileManager.default.fileExists(atPath: url.path) else {
                    return []
                }
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode([Habit].self, from: data)
            },
            save: { habits in
                let data = try JSONEncoder().encode(habits)
                try data.write(to: url, options: .atomic)
            }
        )
    }()
}

extension DependencyValues {
    var habitStorage: HabitStorageClient {
        get { self[HabitStorageClient.self] }
        set { self[HabitStorageClient.self] = newValue }
    }
}
