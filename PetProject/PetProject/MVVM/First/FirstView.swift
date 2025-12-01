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
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                Button {
                    Task {
                        await viewModel.fetchData()
                    }
                } label: {
                    Text("Reload data")
                }
                
                if let warning = viewModel.rainWarning {
                    Text(warning)
                        .font(.headline)
                        .foregroundColor(.blue)
                        .padding(.vertical, 8)
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
                        ForEach(weather.hourly.time.indices, id: \.self) { index in
                            let time = weather.hourly.time[index]
                            let temp = weather.hourly.temperature2m[index]
                            let humidity = weather.hourly.relativeHumidity2m[index]
                            let timeText = DateFormatterService.formatedDate(from: time)
                            
                            let tempText = DateFormatterService.formattedTemperature(
                                temp,
                                unit: AppSettings.shared.temperatureUnit
                            )
                            
                            let windSpeed = weather.current.windSpeed
                            let windText = DateFormatterService.formattedWindSpeed(windSpeed, unit: AppSettings.shared.windSpeedUnit)
                            //let windText = "\(windSpeed)"
                            
                            NavigationLink {
                                DetailsView(timeText: timeText, temperatureText: tempText, humidity: humidity, windSpeedText: windText)
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(timeText)
                                            .font(.subheadline)
                                        Text(tempText)
                                            .font(.caption)
                                            .foregroundColor(.secondary)
                                    }
                                    Spacer()
                                    Text("\(humidity)%")
//                                    Text(windText)
//                                        .font(.caption)
                                }
                                
                            }
                            
                            
                            
                            //                                Text("\(timeText) | \(tempText) | \(humidity)% | \(windSpeed)")
                            
                            
                            
                        }
                    }
                } else if viewModel.isLoading {
                    Text("IS Loading")
                } else {
                    Text("No data")
                }
            }
            .toolbar {
                NavigationLink {
                    SettingView()
                } label: {
                    
                    Image(systemName: "gearshape")

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
}
