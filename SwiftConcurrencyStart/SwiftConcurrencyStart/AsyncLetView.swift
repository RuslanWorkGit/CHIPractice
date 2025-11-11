//
//  AsyncLetView.swift
//  SwiftConcurrencyStart
//
//  Created by user on 11.11.2025.
//

import SwiftUI

struct AsyncLetView: View {
    
    @State private var images: [UIImage] = []
    
    let colums = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: colums) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async LET")
            .onAppear {
                Task {
                    do {
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        
                        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
                        
                        self.images.append(contentsOf: [image1, image2, image3, image4])
                        
                        
//                        let image1 = try await fetchImage()
//                        self.images.append(image1)
//                        
//                        let image2 = try await fetchImage()
//                        self.images.append(image2)
//                        
//                        let image3 = try await fetchImage()
//                        self.images.append(image3)
//                        
//                        let image4 = try await fetchImage()
//                        self.images.append(image4)
                    } catch {
                        
                    }
                }
            }
        }
    }
    
    func fetchImage() async throws -> UIImage {
        do {
            let url = URL(string: "https://picsum.photos/200")!
            
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

#Preview {
    AsyncLetView()
}
