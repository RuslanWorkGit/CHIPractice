//
//  FirstViewModel.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//

import Foundation
import Combine

final class FirstViewModel: ObservableObject {
    
    @Published var weatherResult: WeatherForecastResponse?
    @Published var isLoading = false
    
    private let client = WeatherAPIClient()
    
    func fetchData() async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            let forecast = try await client.fetchForecast(latitude: 50.45, longitude: 30.52)
            weatherResult = forecast
        } catch {
            print("ERROR Fetch \(error.localizedDescription)")
        }
    }
}
