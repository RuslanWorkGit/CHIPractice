//
//  ContentView.swift
//  FoundationModelTest
//
//  Created by user on 01.12.2025.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = StudyPlannerViewModel()
    @State private var generationTask: Task<Void, Never>?
    
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
                
                //                Button {
                //                    if viewModel.isGenerating {
                //                        generationTask?.cancel()
                //                        generationTask = nil
                //                    } else {
                //                        generationTask = Task {
                //                            await viewModel.generate()
                //                            generationTask = nil
                //                        }
                //                    }
                //
                //                } label: {
                //                    HStack {
                //                        if viewModel.isGenerating {
                //                            Image(systemName: "stop.fill")
                //                            Text("Stop")
                //                        } else {
                //                            Text("Generate plan")
                //                        }
                //                    }
                //                    .frame(maxWidth: .infinity)
                //
                //                }
                //                .buttonStyle(.borderedProminent)
                //                .padding(.horizontal)
                
                // Chat
                chatList
                
                
                // Error
                if let error = viewModel.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.footnote)
                        .padding(.horizontal)
                }
                
                inputBar
                
                // Result
//                ScrollView {
//                    Text(viewModel.resultText.isEmpty ? "A plan will appear here" : viewModel.resultText)
//                        .frame(maxWidth: .infinity, alignment: .leading)
//                        .padding()
//                }
            }
            .navigationTitle("StudyPlanner AI")
        }
    }
    
    private var chatList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        messageBubble(message)
                            .id(message.id)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)
            }
            .onChange(of: viewModel.messages.count) { _ in
                if let lastId = viewModel.messages.last?.id {
                    withAnimation {
                        proxy.scrollTo(lastId, anchor: .bottom)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func messageBubble(_ message: ChatMessage) -> some View {
        HStack {
            if message.role == .assistant {
                // Асистент зліва
                VStack(alignment: .leading) {
                    Text(message.text)
                        .padding(10)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(12)
                }
                Spacer()
            } else {
                // Юзер справа
                Spacer()
                VStack(alignment: .trailing) {
                    Text(message.text)
                        .padding(10)
                        .background(Color.green.opacity(0.2))
                        .cornerRadius(12)
                }
            }
        }
    }
    
    // MARK: - Input bar
    
    private var inputBar: some View {
        HStack(alignment: .bottom, spacing: 8) {
            TextField("Asked aboun new plan...",
                      text: $viewModel.inputText,
                      axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(1...4)
            
            Button {
                if viewModel.isGenerating {
                    // STOP
                    generationTask?.cancel()
                    generationTask = nil
                } else {
                    // SEND
                    let textIsEmpty = viewModel
                        .inputText
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                        .isEmpty
                    if textIsEmpty { return }
                    
                    generationTask = Task {
                        await viewModel.send()
                        generationTask = nil
                    }
                }
            } label: {
                if viewModel.isGenerating {
                    Image(systemName: "stop.fill")
                        .font(.system(size: 18))
                } else {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 24))
                }
            }
            .padding(.bottom, 4)
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}


#Preview {
    ContentView()
}
