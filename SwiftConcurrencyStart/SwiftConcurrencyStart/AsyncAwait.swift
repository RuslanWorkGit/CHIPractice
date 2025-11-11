//
//  AsyncAwait.swift
//  SwiftConcurrencyStart
//
//  Created by user on 11.11.2025.
//

import SwiftUI
import Combine

class AsyncAwaitViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1 : \(Thread.current)")
        }
        
    }
    
    func addTitle2() {
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title2 : \(Thread.current)"
            
            DispatchQueue.main.async {
                self.dataArray.append(title)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author 1: \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        //try? await doSomething()
        
        let author2 = "Author 2: \(Thread.current)"
        
        await MainActor.run {
            self.dataArray.append(author2)
            
            let author3 = "Author 3: \(Thread.current)"
            self.dataArray.append(author3)
        }
        
        await addSomething()
        
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        
        let something1 = "Something 1: \(Thread.current)"
        
        await MainActor.run {
            self.dataArray.append(something1)
            
            let something2 = "Something 2: \(Thread.current)"
            self.dataArray.append(something2)
        }
    }
    
}

struct AsyncAwait: View {
    
    
    @StateObject private var viewModel = AsyncAwaitViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id: \.self) { data in
                Text(data)
            }
        }
        .onAppear {
            Task {
                await viewModel.addAuthor1()
                
                let finalText = "FINAL TEXT: \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
    }
}

#Preview {
    AsyncAwait()
}
