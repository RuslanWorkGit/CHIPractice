//
//  DoCatchTryThroowsBootcamp.swift
//  SwiftConcurrencyStart
//
//  Created by user on 10.11.2025.
//

import SwiftUI
import Combine


//do-catch
//try
//throws
class DoCatchTryTrhowsDataManager {
    
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT!", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("NEW TEXT!")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
            return "NEW TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "Final TEXT!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoTryCatchThrowsViewModel: ObservableObject {

    @Published var text: String = "Starting text."
    
    let manager = DoCatchTryTrhowsDataManager()
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = "Error: \(error.localizedDescription)"
        }
         */
        
        /*
        let result = manager.getTitle2()
        switch result {
        case .success(let newTitle):
            self.text = newTitle
        case .failure(let error):
            self.text = error.localizedDescription
        }
         */
        do {
            let newTitle = try manager.getTitle3()
            self.text = newTitle
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
        
        
    }
    
}

struct DoCatchTryThroowsBootcamp: View {
    
    @StateObject private var viewModels = DoTryCatchThrowsViewModel()
    
    var body: some View {
        Text(viewModels.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModels.fetchTitle()
            }
            
            
    }
}

#Preview {
    DoCatchTryThroowsBootcamp()
}
