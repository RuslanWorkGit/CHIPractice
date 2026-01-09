//
//  StudyAIViewModel.swift
//  FoundationModelTest
//
//  Created by user on 02.12.2025.
//

import Foundation
import Combine

enum ChatRoleAI {
    case user
    case assistant
}

struct ChatMessageAI: Identifiable {
    let id = UUID()
    let role: ChatRoleAI
    var text: String
}

@MainActor
final class StudyAIViewModel: ObservableObject {

    @Published var messages: [ChatMessageAI] = []
    @Published var isGenerating = false

    private let aiService = StudyPlanAIService()

//    func send(_ userText: String) {
//        guard !userText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
//
//        messages.append(ChatMessageAI(role: .user, text: userText))
//        isGenerating = true
//
//        Task {
//            do {
//                let plan = try await aiService.generatePlan(for: userText)
//                let formatted = Self.format(plan: plan)
//
//                await MainActor.run {
//                    self.messages.append(ChatMessageAI(role: .assistant, text: formatted))
//                    self.isGenerating = false
//                }
//            } catch {
//                await MainActor.run {
//                    self.messages.append(
//                        ChatMessageAI(
//                            role: .assistant,
//                            text: "Error during building plan: \(error.localizedDescription)"
//                        )
//                    )
//                    self.isGenerating = false
//                }
//            }
//        }
//    }

    func send(_ userText: String) {
            let trimmed = userText.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { return }

            // 1. додаємо повідомлення користувача
            messages.append(ChatMessageAI(role: .user, text: trimmed))
            isGenerating = true

            // 2. додаємо пусте повідомлення асистента, яке будемо стрімити
            var assistantMessage = ChatMessageAI(role: .assistant, text: "")
            messages.append(assistantMessage)
            let assistantId = assistantMessage.id

            Task { [weak self] in
                guard let self else { return }

                do {
                    let finalPlan = try await aiService.streamResponse(
                        for: trimmed,
                        onPartial: { [weak self] partial in
                            guard let self else { return }
                            let formatted = Self.format(partialPlan: partial)

                            if let index = self.messages.firstIndex(where: { $0.id == assistantId }) {
                                self.messages[index].text = formatted
                            }
                        }
                    )

                    // Після завершення стріму — оновлюємо фінальною версією
                    let finalText = Self.format(plan: finalPlan)
                    if let index = self.messages.firstIndex(where: { $0.id == assistantId }) {
                        self.messages[index].text = finalText
                    }

                    self.isGenerating = false
                } catch {
                    if let index = self.messages.firstIndex(where: { $0.id == assistantId }) {
                        self.messages[index].text = "Error during building plan: \(error.localizedDescription)"
                    } else {
                        self.messages.append(
                            ChatMessageAI(role: .assistant,
                                          text: "Error during building plan: \(error.localizedDescription)")
                        )
                    }
                    self.isGenerating = false
                }
            }
        }
    
    // MARK: - Formatting

    private static func format(plan: StudyPlan) -> String {
        var lines: [String] = []

        lines.append("Study plan: \(plan.subject) (\(plan.level))")
        lines.append("Duration: \(plan.totalWeeks) weeks")
        lines.append("")

        for week in plan.weeks {
            lines.append("Week \(week.weekNumber): \(week.focusTopic)")
            for task in week.tasks {
                lines.append(" • \(task)")
            }
            lines.append(" ≈ \(week.approximateHours) h/week")
            lines.append("")
        }

        return lines.joined(separator: "\n")
    }
    
    private static func format(partialPlan: StudyPlan.PartiallyGenerated) -> String {
            var lines: [String] = []

            if let subject = partialPlan.subject,
               let level = partialPlan.level,
               let totalWeeks = partialPlan.totalWeeks {
                lines.append("Study plan: \(subject) (\(level))")
                lines.append("Duration: \(totalWeeks) weeks")
                lines.append("")
            }

            if let weeks = partialPlan.weeks {
                for week in weeks {
                    // Build parts conditionally based on available fields
                    if let weekNumber = week.weekNumber, let focusTopic = week.focusTopic {
                        lines.append("Week \(weekNumber): \(focusTopic)")
                    } else if let weekNumber = week.weekNumber {
                        lines.append("Week \(weekNumber)")
                    } else if let focusTopic = week.focusTopic {
                        lines.append(focusTopic)
                    }

                    if let tasks = week.tasks {
                        for task in tasks {
                            // `task` is already a String (non-optional) according to the error; append directly
                            lines.append(" • \(task)")
                        }
                    }

                    if let hours = week.approximateHours {
                        lines.append(" ≈ \(hours) h/week")
                    }

                    // Add a trailing empty line if we appended anything for this week
                    if !lines.isEmpty, lines.last != "" { lines.append("") }
                }
            }

            return lines.joined(separator: "\n")
        }

}
