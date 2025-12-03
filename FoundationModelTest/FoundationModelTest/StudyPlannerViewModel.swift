//
//  StudyPlannerViewModel.swift
//  FoundationModelTest
//
//  Created by user on 01.12.2025.
//

import Foundation
import Combine


@MainActor
final class StudyPlannerViewModel: ObservableObject {
    
    
    enum Level: String, CaseIterable, Identifiable {
        case beginner = "Beginner"
        case intermediate = "Intermediate"
        case advanced = "Advanced"
        
        var id: String { rawValue }
        
        var title: String {
            switch self {
            case .beginner:     return "Beginer"
            case .intermediate: return "Middle"
            case .advanced:     return "Advanced"
            }
        }
    }
    
    @Published var subject: String = ""
    @Published var selectedLevel: Level = .beginner
    @Published var weeks: Int = 4
    
    @Published var resultText: String = ""
    @Published var isGenerating = false
    @Published var errorMessage: String?
    
    @Published var messages: [ChatMessage] = []
    @Published var inputText: String = ""
    
    
    private let service = StudyPlannerService()
    
    init() {
        // Початкове повідомлення асистента (опціонально)
        messages.append(
            ChatMessage(
                role: .assistant,
                text: "Hello! Enter the topic, choose the level and number of weeks — I will create a curriculum"
            )
        )
    }
    
    func generate() async {
        guard !subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Enter a topic"
            return
        }
        
        isGenerating = true
        errorMessage = nil
        resultText = ""
        
        defer {
            isGenerating = false
        }
        
        
        do {
            //            let plan = try await service.generatePlan(
            //                subject: subject,
            //                level: selectedLevel.rawValue,
            //                weeks: weeks
            //            )
            //            resultText = plan
            try await service.streamPlan(subject: subject, level: selectedLevel.rawValue, weeks: weeks) { [weak self] partial in
                guard let self = self, !Task.isCancelled else { return }
                self.resultText = partial
            }
        } catch is CancellationError {
            
        } catch let AIAvailabilityError.unavailable(reason) {
            errorMessage = "Model unavalable: \(reason)"
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }
        
        isGenerating = false
    }
    
    func send() async {
        let trimmed = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            errorMessage = "Ask a quateion or topic"
            return
        }
        
        let userMessage = ChatMessage(role: .user, text: trimmed)
        messages.append(userMessage)
        inputText = ""
        errorMessage = nil
        
        let assistantIndex = messages.count
        messages.append(ChatMessage(role: .assistant, text: ""))
        
        isGenerating = true
        defer { isGenerating = false }
        
        do {
            try await service.streamPlan(
                subject: trimmed,
                level: selectedLevel.rawValue,
                weeks: weeks
            ) { [weak self] partial in
                guard let self = self else { return }
                guard !Task.isCancelled else { return }
                
                // Оновлюємо текст останнього assistant-повідомлення
                if assistantIndex < self.messages.count {
                    self.messages[assistantIndex].text = partial
                }
            }
        } catch is CancellationError {
            // STOP
        } catch let AIAvailabilityError.unavailable(reason) {
            errorMessage = "Модель недоступна: \(reason)"
        } catch {
            errorMessage = "Сталася помилка: \(error.localizedDescription)"
        }
    }
}
