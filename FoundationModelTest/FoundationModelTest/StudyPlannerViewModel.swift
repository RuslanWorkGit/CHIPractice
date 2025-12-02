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


    private let service = StudyPlannerService()

    func generate() async {
        guard !subject.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Enter a topic"
            return
        }

        isGenerating = true
        errorMessage = nil
        resultText = ""
        

        do {
//            let plan = try await service.generatePlan(
//                subject: subject,
//                level: selectedLevel.rawValue,
//                weeks: weeks
//            )
//            resultText = plan
            try await service.streamPlan(subject: subject, level: selectedLevel.rawValue, weeks: weeks) { [weak self] partial in
                self?.resultText = partial
            }
        } catch let AIAvailabilityError.unavailable(reason) {
            errorMessage = "Model unavalable: \(reason)"
        } catch {
            errorMessage = "Error: \(error.localizedDescription)"
        }

        isGenerating = false
    }
}
