//
//  Habit.swift
//  TCATest
//
//  Created by user on 08.12.2025.
//

import Foundation
import ComposableArchitecture

struct Habit: Equatable, Identifiable, Codable {
    let id: UUID
    var title: String
    var notes: String
    var isCompletedToday: Bool
}
