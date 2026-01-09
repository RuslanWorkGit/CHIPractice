//
//  StudyPlanAiService.swift
//  FoundationModelTest
//
//  Created by user on 02.12.2025.
//

import Foundation
import FoundationModels

@MainActor
final class StudyPlanAIService {
    
    private let session: LanguageModelSession
    
    init() {
        // Інструкції для моделі (хто ти і що робиш)
        self.session = LanguageModelSession(
            instructions: """
            You are a helpful study planner assistant.
            You always respond by generating a realistic, structured study plan
            for the given topic, following the provided Swift schema.
            Focus on practical, achievable weekly goals.
            """
        )
    }
    
    func generatePlan(for prompt: String) async throws -> StudyPlan {
        let response = try await session.respond(
            to: """
            Create a study plan for the following request:
            
            "\(prompt)"
            
            The plan should be realistic for a busy student who has limited time
            on weekdays and can study a bit more on weekends.
            """,
            generating: StudyPlan.self   // <— guided generation
        )
        return response.content
    }
    
    func streamResponse(
        for prompt: String,
        onPartial: @escaping (StudyPlan.PartiallyGenerated) -> Void
    ) async throws -> StudyPlan {
        
        let stream = session.streamResponse(
            to: """
                Create a study plan for the following request:
                
                "\(prompt)"
                
                The plan should be realistic for a busy student who has limited time
                on weekdays and can study a bit more on weekends.
                """,
            generating: StudyPlan.self
        )
        
        // Stream online updates
        for try await snapshot in stream {
            onPartial(snapshot.content)
        }
        
        // final results
        let finalResponse = try await stream.collect()
        return finalResponse.content
    }
}
