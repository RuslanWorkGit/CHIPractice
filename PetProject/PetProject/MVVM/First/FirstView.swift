//
//  FirstView.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//

//import SwiftUI
//
//struct FirstView: View {
//    @StateObject private var viewModel = FirstViewModel()
//    
//    var body: some View {
//        VStack {
//            
//            Button {
//                Task {
//                    await viewModel.fetchData()
//                }
//            } label: {
//                Text("Reload data")
//            }
//
//            if let weather = viewModel.weatherResult {
//                Text("Latitude: \(weather.latitude)")
//                Text("Longitude: \(weather.longitude)")
//                Text("Timezone: \(weather.timezone)")
//                
//                List{
//                    ForEach(Array(weather.hourly.time.enumerated()), id: \.offset) { index, time in
//                        let temp = weather.hourly.temperature2m[index]
//                        let humidity = weather.hourly.relativeHumidity2m[index]
//                        let timeText = DateFormatterService.formatedDate(from: time)
//                        
//                        Text("\(timeText) | \(temp, specifier: "%.1f")C | \(humidity, specifier: "%.1f")")
//                    }
//                }
//            } else if viewModel.isLoading {
//                Text("IS Loading")
//            } else {
//                Text("No data")
//            }
//            
//        }
//        .task {
//            await viewModel.fetchData()
//        }
//    }
//}


import SwiftUI

struct FirstView: View {
    @StateObject private var viewModel = FirstViewModel()
    
    var body: some View {
        VStack {
            
            Button {
                Task {
                    await viewModel.fetchData()
                }
            } label: {
                Text("Reload data")
            }
            
            if let lastUpdate = viewModel.lastUpdateText {
                Text("Last update: \(lastUpdate)")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            
            if let weather = viewModel.weatherResult {
                Text("Latitude: \(weather.latitude)")
                Text("Longitude: \(weather.longitude)")
                Text("Timezone: \(weather.timezone)")
                
                List {
                    ForEach(Array(weather.hourly.time.enumerated()), id: \.offset) { index, time in
                        let temp = weather.hourly.temperature2m[index]
                        let humidity = weather.hourly.relativeHumidity2m[index]
                        let timeText = DateFormatterService.formatedDate(from: time)
                        
                        let tempText = DateFormatterService.formattedTemperature(
                            temp,
                            unit: AppSettings.shared.temperatureUnit
                        )
                        
                        Text("\(timeText) | \(tempText) | \(humidity)%")
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
        .onAppear {
            viewModel.startAutoRefresh()
        }
    }
}
