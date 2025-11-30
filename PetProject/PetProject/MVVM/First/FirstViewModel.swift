//
//  FirstViewModel.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//

//import Foundation
//import Combine
//
//final class FirstViewModel: ObservableObject {
//    
//    @Published var weatherResult: WeatherForecastResponse?
//    @Published var isLoading = false
//    
//    private let client = WeatherAPIClient()
//    
//    func fetchData() async {
//        isLoading = true
//        defer { isLoading = false }
//        
//        do {
//            let forecast = try await client.fetchForecast(latitude: 50.45, longitude: 30.52)
//            weatherResult = forecast
//        } catch {
//            print("ERROR Fetch \(error.localizedDescription)")
//        }
//    }
//}


import Foundation
import Combine

@MainActor
final class FirstViewModel: ObservableObject {
    
    @Published var weatherResult: WeatherForecastResponse?
    @Published var isLoading = false
    @Published var lastUpdateText: String?
    
    private let client = WeatherAPIClient()
    private let storage = WeatherStorage.shared
    private var refreshTimer: Timer?
    
    deinit {
        refreshTimer?.invalidate()
    }
    
    func fetchData() async {
        isLoading = true
        defer { isLoading = false }
        
        // Беремо останню локацію з налаштувань, або дефолт (Київ)
        let coordinates = AppSettings.shared.lastLocation() ?? (50.45, 30.52)
        
        do {
            let forecast = try await client.fetchForecast(latitude: coordinates.lat,
                                                          longitude: coordinates.lon)
            weatherResult = forecast
            
            AppSettings.shared.saveLastLocation(latitude: coordinates.lat,
                                                longitude: coordinates.lon)
            AppSettings.shared.lastUpdateDate = Date()
            
            storage.saveForecast(forecast)
            updateLastUpdateText()
            
        } catch {
            print("ERROR Fetch \(error.localizedDescription)")
            
            // Якщо мережа впала – дістаємо з кешу
            if let cached = storage.loadForecast() {
                weatherResult = cached.forecast
                AppSettings.shared.lastUpdateDate = cached.savedAt
                updateLastUpdateText()
            }
        }
    }
    
    func startAutoRefresh(interval: TimeInterval = 60 * 10) {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval,
                                            repeats: true) { [weak self] _ in
            Task { await self?.fetchData() }
        }
    }
    
    private func updateLastUpdateText() {
        if let date = AppSettings.shared.lastUpdateDate {
            lastUpdateText = DateFormatterService.formattedRelativeDate(from: date)
        } else {
            lastUpdateText = nil
        }
    }
}
