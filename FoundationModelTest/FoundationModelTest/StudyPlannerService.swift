//
//  StudyPlannerService.swift
//  FoundationModelTest
//
//  Created by user on 01.12.2025.
//

import Foundation
import FoundationModels

enum AIAvailabilityError: Error {
    case unavailable(reason: String)
}

@MainActor
final class StudyPlannerService {
    
    private let model = SystemLanguageModel.default
    private lazy var session = LanguageModelSession(
        instructions: """
        You are an experienced study coach.
        Create clear and practical study plans.
        Always structure the answer by weeks with bullet points.
        """
    )
    
    func generatePlan(
        subject: String,
        level: String,
        weeks: Int
    ) async throws -> String {
        
        // 1. Перевіряємо, що модель взагалі доступна
        switch model.availability {
        case .available:
            break
        case .unavailable(let reason):
            throw AIAvailabilityError.unavailable(reason: "\(reason)")
        }
        
        // 2. Формуємо промпт
        let prompt = """
        Create a \(weeks)-week study plan for the topic: "\(subject)".
        
        Student level: \(level).
        
        For each week:
        - Give a short title.
        - List 3–5 concrete tasks (reading, practice, mini-projects).
        - Approximate hours per week.
        """
        
        // 3. Виклик моделі
        let response = try await session.respond(to: prompt)
        return response.content
    }
    
    func streamPlan(
        subject: String,
        level: String,
        weeks: Int,
        onPartial: @escaping (String) -> Void
    ) async throws {
        guard case .available = model.availability else {
            throw AIAvailabilityError.unavailable(reason: "Model not available")
        }
        
        let prompt = """
            Create a \(weeks)-week study plan for the topic: "\(subject)".
            
            Student level: \(level).
            
            For each week:
            - Give a short title.
            - List 3–5 concrete tasks.
            - Approximate hours per week.
            """
        
        let stream = session.streamResponse(to: prompt)
        
        for try await partial in stream {
            if Task.isCancelled {
                break
            }
            onPartial(partial.content)
        }
    }
}
