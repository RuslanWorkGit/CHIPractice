//
//  FirstView.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//

import SwiftUI

struct FirstView: View {
    @StateObject private var viewModel = FirstViewModel()
    
    var body: some View {
        VStack {
            if let weather = viewModel.weatherResult {
                Text("Latitude: \(weather.latitude)")
                Text("Longitude: \(weather.longitude)")
                Text("Timezone: \(weather.timezone)")
                
                List{
                    ForEach(Array(weather.hourly.time.enumerated()), id: \.offset) { index, time in
                        let temp = weather.hourly.relativehumidity2m[index]
                        let humidity = weather.hourly.relativehumidity2m[index]
                        
                        Text("\(time) | \(temp, specifier: "%.1f")C | \(humidity, specifier: "%.1f")")
                    }
                }
            } else if viewModel.isLoading {
                Text("IS Loading")
            } else {
                Text("No data")
            }
            
        }
        .task {
            await viewModel.fetchData()
        }
    }
}
