//
//  StudyPlanModels.swift
//  FoundationModelTest
//
//  Created by user on 02.12.2025.
//

// StudyPlanModels.swift

import Foundation
import FoundationModels

@Generable
struct StudyPlan: Equatable {
    @Guide(description: "Short subject name, e.g. 'iOS Concurrency', 'Linear Algebra'")
    let subject: String

    @Guide(description: "Level like Beginner, Intermediate, or Advanced")
    let level: String

    @Guide(description: "Total number of weeks in this study plan", .range(1...12))
    let totalWeeks: Int

    @Guide(
        description: "One entry per study week in chronological order",
        .minimumCount(1),
        .maximumCount(12)
    )
    let weeks: [WeekPlan]
}

@Generable
struct WeekPlan: Equatable {
    @Guide(description: "Week number starting from 1", .range(1...12))
    let weekNumber: Int

    @Guide(description: "Short focus topic for this week")
    let focusTopic: String

    @Guide(description: "3–5 actionable study tasks for this week", .count(3...5))
    let tasks: [String]

    @Guide(description: "Approximate total study hours for the week", .range(2...25))
    let approximateHours: Int
}
