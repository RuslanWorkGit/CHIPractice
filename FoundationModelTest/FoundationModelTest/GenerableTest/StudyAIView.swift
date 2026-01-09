//
//  StudyAIView.swift
//  FoundationModelTest
//
//  Created by user on 02.12.2025.
//
import SwiftUI

struct StudyAIView: View {
    
    @StateObject private var viewModel = StudyAIViewModel()
    @State private var inputText: String = ""
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 12) {
                    ForEach(viewModel.messages) { message in
                        HStack {
                            if message.role == .assistant {
                                Text(message.text)
                                    .padding(10)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            } else {
                                Text(message.text)
                                    .padding(10)
                                    .background(Color.green.opacity(0.1))
                                    .cornerRadius(8)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    }
                    
                    if viewModel.isGenerating {
                        ProgressView("Generating plan…")
                            .padding(.top, 8)
                    }
                }
                .padding()
            }
            
            HStack {
                TextField("What do you whant to learn?", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                
                Button("Send") {
                    let text = inputText
                    inputText = ""
                    viewModel.send(text)
                }
                .disabled(viewModel.isGenerating)
            }
            .padding()
        }
    }
}

#Preview {
    StudyAIView()
}
