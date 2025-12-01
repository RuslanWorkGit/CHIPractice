//
//  DetailsView.swift
//  PetProject
//
//  Created by user on 01.12.2025.
//

import SwiftUI

struct DetailsView: View {
    
    let timeText: String
    let temperatureText: String
    let humidity: Int
    let windSpeedText: String
    
    var body: some View {
            VStack(spacing: 16) {
                Text(timeText)
                    .font(.title2)
                
                Text("Temperature: \(temperatureText)")
                Text("Humidity: \(humidity)%")
                Text("Wind: \(windSpeedText)")
            }
            .padding()
            .navigationTitle("Details")
            .navigationBarTitleDisplayMode(.inline)
        }
}

//#Preview {
//    DetailsView()
//}
