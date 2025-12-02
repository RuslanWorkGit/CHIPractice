 //
//  ContentView.swift
//  FoundationModelTest
//
//  Created by user on 01.12.2025.
//

import SwiftUI

struct ContentView: View {

    @StateObject private var viewModel = StudyPlannerViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                // Ввід теми
                TextField("Topic (e.g. Swift Concurrency)",
                          text: $viewModel.subject)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal)

                // Рівень
                Picker("Level", selection: $viewModel.selectedLevel) {
                    ForEach(StudyPlannerViewModel.Level.allCases) { level in
                        Text(level.title).tag(level)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                // Кількість тижнів
                Stepper("Number of weeks: \(viewModel.weeks)",
                        value: $viewModel.weeks,
                        in: 1...12)
                .padding(.horizontal)

                // Кнопка генерації
                Button {
                    Task {
                        await viewModel.generate()
                    }
                } label: {
                    if viewModel.isGenerating {
                        ProgressView()
                            .padding(.horizontal)
                    } else {
                        Text("Generate plan")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding(.horizontal)
                .disabled(viewModel.isGenerating)

                // Помилка
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }

                // Результат
                ScrollView {
                    Text(viewModel.resultText.isEmpty ? "A plan will appear here" : viewModel.resultText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                }
            }
            .navigationTitle("StudyPlanner AI")
        }
    }
}


#Preview {
    ContentView()
}
