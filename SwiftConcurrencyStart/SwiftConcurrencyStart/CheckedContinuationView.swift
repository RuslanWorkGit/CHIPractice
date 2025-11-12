//
//  CheckedContinuationView.swift
//  SwiftConcurrencyStart
//
//  Created by user on 12.11.2025.
//

import SwiftUI
import Combine

class CheckedContinuationNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
            
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            return data
            
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.badURL))
                }
                
               
            }
            .resume()
        }
        
        
    }
    
    
    func getHeartImageFromDatabase(completionHandler: @escaping (_ image: UIImage) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromDatabase2() async  -> UIImage {
        return await withCheckedContinuation { continuation in
            getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
    
}

class CheckedContinuationViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        
        do {
//            let data = try await networkManager.getData(url: url)
            let data = try await networkManager.getData2(url: url)

            
            if let image = UIImage(data: data) {
                await MainActor.run {
                    self.image = image
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getHeartImage() async {
//        networkManager.getHeartImageFromDatabase { [weak self] image in
//            self?.image = image
//        }
        

            self.image = await networkManager.getHeartImageFromDatabase2()
        
        
    }
}

struct CheckedContinuationView: View {
    
    @StateObject private var viewModel = CheckedContinuationViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            //await viewModel.getImage()
            
            await viewModel.getHeartImage()
            
        }
    }
}

#Preview {
    CheckedContinuationView()
}
