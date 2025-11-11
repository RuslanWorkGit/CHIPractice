//
//  TaskGroupView.swift
//  SwiftConcurrencyStart
//
//  Created by user on 11.11.2025.
//

import SwiftUI
import Combine

class TaskGroupDataManager {
    
    // let url = URL(string: "https://picsum.photos/200")!
    
    func fetchImageWithAsyncLet() async throws -> [UIImage] {
   
            async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/200")
            async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/200")
            async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/200")
            async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/200")
            
            let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
            
            let imgArr = [image1, image2, image3, image4]
            
            return imgArr
        
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        
        let urlStrings = [
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200"
        ]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            //якщо знати кількість елементів то можна зарезервувати кількість в памʼяті одразу
            images.reserveCapacity(urlStrings.count)
            
            for urlString in urlStrings {
                group.addTask {
                    //try? допомагає уникнути випадків якщо є 1 помилка то повертається поимлка для усього, в цьому випадку повренться просто nil для 1 елементу
                    try? await self.fetchImage(urlString: urlString)
                }
            }
            
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
//            group.addTask {
//                try await self.fetchImage(urlString: "https://picsum.photos/200")
//            }
            
            for try await image in group {
                if let image = image {
                    images.append(image)
                }
                
            }
            
//            group.addTask(priority: <#T##TaskPriority?#>, operation: <#T##() async throws -> UIImage#>)
        
            return images
        }
        
    }
    
    private func fetchImage(urlString: String) async throws -> UIImage {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url, delegate: nil)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
    
}


class TaskGroupViewModel: ObservableObject {
    @Published var images: [UIImage] = []
    let manager = TaskGroupDataManager()
    
    func getImages() async {
//        if let images = try? await manager.fetchImageWithAsyncLet() {
//            self.images.append(contentsOf: images)
//        }
        
        if let images = try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: images)
        }
    }
}

struct TaskGroupView: View {
    
    @StateObject private var viewModel = TaskGroupViewModel()
    
    let colums = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: colums) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group")
            .task {
                await viewModel.getImages()
                
            }
        }
        
    }
}

#Preview {
    TaskGroupView()
}
