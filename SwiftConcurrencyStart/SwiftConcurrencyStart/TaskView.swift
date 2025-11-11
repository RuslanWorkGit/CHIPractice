//
//  TaskView.swift
//  SwiftConcurrencyStart
//
//  Created by user on 11.11.2025.
//

import SwiftUI
import Combine

class TaskViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    
    @Published var image2: UIImage? = nil
    
    func fetchImage() async {
        
        try? await Task.sleep(for: .seconds(5))
        
//        for x in array {
//            try Task.checkCancellation()
//        }
        
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            
//            let image = UIImage(data: data)
//            self.image = image
            await MainActor.run {
                let image = UIImage(data: data)
                self.image = image
                print("Image returned successfuly")
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            
//            let image = UIImage(data: data)
//            self.image2 = image
            
            await MainActor.run {
                let image = UIImage(data: data)
                self.image2 = image
                print("Image returned successfuly")
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
}

struct TaskHomeView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                NavigationLink("CLICK ME!!!") {
                    TaskView()
                }
            }
        }
    }
}

struct TaskView: View {
    
    @StateObject private var viewModel = TaskViewModel()
    @State private var  fetchImageTask: Task<(), Never>? = nil
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            fetchImageTask?.cancel()
//        }
        .onAppear {
//            fetchImageTask = Task {
//                await viewModel.fetchImage()
//                
//            }
//            
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
            
//            Task(priority: .high) {
//                //try? await Task.sleep(nanoseconds: 2_000_000_000)
//                await Task.yield()
//                print("HIGH  \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("USERINITIATED  \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .medium) {
//                print("MEDIUM  \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("LOW  \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("UTILITY  \(Thread.current) : \(Task.currentPriority)")
//            }
//            Task(priority: .background) {
//                print("BACGROUND  \(Thread.current) : \(Task.currentPriority)")
//            }
            
//            Task(priority: .low) {
//                print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
//                
//                Task.detached {
//                    print("userInitiated: \(Thread.current) : \(Task.currentPriority)")
//                }
//            }
            
            
            
        }
    }
}

#Preview {
    TaskView()
}
