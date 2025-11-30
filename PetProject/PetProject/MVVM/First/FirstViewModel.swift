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


//import Foundation
//import Combine
//
//@MainActor
//final class FirstViewModel: ObservableObject {
//    
//    @Published var weatherResult: WeatherForecastResponse?
//    @Published var isLoading = false
//    @Published var lastUpdateText: String?
//    @Published var rainWarning: String?
//    
//    private let client = WeatherAPIClient()
//    private let storage = WeatherStorage.shared
//    private var refreshTimer: Timer?
//    
//    private let rainThreshold = 0.1
//    
//    deinit {
//        refreshTimer?.invalidate()
//    }
//    
//    func fetchData() async {
//        isLoading = true
//        defer { isLoading = false }
//        
//        // Беремо останню локацію з налаштувань, або дефолт (Київ)
//        let coordinates = AppSettings.shared.lastLocation() ?? (50.45, 30.52)
//        
//        do {
//            let forecast = try await client.fetchForecast(latitude: coordinates.lat,
//                                                          longitude: coordinates.lon)
//            weatherResult = forecast
//            
//            AppSettings.shared.saveLastLocation(latitude: coordinates.lat,
//                                                longitude: coordinates.lon)
//            AppSettings.shared.lastUpdateDate = Date()
//            
//            storage.saveForecast(forecast)
//            updateLastUpdateText()
//            updateRainWarning()
//            
//        } catch {
//            print("ERROR Fetch \(error.localizedDescription)")
//            
//            // Якщо мережа впала – дістаємо з кешу
//            if let cached = storage.loadForecast() {
//                weatherResult = cached.forecast
//                AppSettings.shared.lastUpdateDate = cached.savedAt
//                updateLastUpdateText()
//            }
//        }
//    }
//    
//    func startAutoRefresh(interval: TimeInterval = 60 * 10) {
//        refreshTimer?.invalidate()
//        refreshTimer = Timer.scheduledTimer(withTimeInterval: interval,
//                                            repeats: true) { [weak self] _ in
//            Task { await self?.fetchData() }
//        }
//    }
//    
//    private func updateLastUpdateText() {
//        if let date = AppSettings.shared.lastUpdateDate {
//            lastUpdateText = DateFormatterService.formattedRelativeDate(from: date)
//        } else {
//            lastUpdateText = nil
//        }
//    }
//    
//    private func updateRainWarning() {
//        guard let hourly = weatherResult?.hourly else {
//            rainWarning = nil
//            return
//        }
//        
//        let now = Date()
//        
//        // time і precipitation синхронні за індексом
//        for (index, amount) in hourly.precipitation.enumerated() {
//            // шукаємо перший час, коли опади > порога
//            guard amount > rainThreshold else { continue }
//            
//            let timeString = hourly.time[index]
//            guard let date = DateFormatterService.date(from: timeString) else { continue }
//            guard date > now else { continue } // пропускаємо те, що вже у минулому
//            
//            if let intervalString = DateFormatterService.timeIntervalString(from: now, to: date) {
//                // тут ми самі додаємо "через", бо DateComponentsFormatter не знає про минуле/майбутнє,
//                // він форматує лише тривалість (duration) :contentReference[oaicite:2]{index=2}
//                rainWarning = "Дощ очікується через \(intervalString)"
//            } else {
//                rainWarning = nil
//            }
//            
//            return
//        }
//        
//        // якщо в найближчих годинах опадів немає
//        rainWarning = "У найближчий час дощу не очікується"
//    }
//}

import Foundation
import Combine

@MainActor
final class FirstViewModel: ObservableObject {

    @Published var weatherResult: WeatherForecastResponse?
    @Published var isLoading = false
    @Published var lastUpdateText: String?
    @Published var rainWarning: String?

    private let client = WeatherAPIClient()
    private let storage = WeatherStorage.shared
    private var refreshTimer: Timer?

    deinit {
        refreshTimer?.invalidate()
    }

    // MARK: - API

    func fetchData() async {
        isLoading = true
        defer { isLoading = false }

        // Беремо останню локацію з налаштувань, або дефолт (Київ)
        let coordinates = AppSettings.shared.lastLocation() ?? (50.45, 30.52)

        do {
            let forecast = try await client.fetchForecast(
                latitude: coordinates.lat,
                longitude: coordinates.lon
            )
            weatherResult = forecast

            AppSettings.shared.saveLastLocation(
                latitude: coordinates.lat,
                longitude: coordinates.lon
            )
            AppSettings.shared.lastUpdateDate = Date()

            storage.saveForecast(forecast)
            updateLastUpdateText()
            updateRainWarning()

        } catch {
            print("ERROR Fetch \(error.localizedDescription)")

            // Якщо мережа впала – дістаємо з кешу
            if let cached = storage.loadForecast() {
                weatherResult = cached.forecast
                AppSettings.shared.lastUpdateDate = cached.savedAt
                updateLastUpdateText()
                updateRainWarning()
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

    // MARK: - Helpers

    private func updateLastUpdateText() {
        if let date = AppSettings.shared.lastUpdateDate {
            lastUpdateText = DateFormatterService.formattedRelativeDate(from: date)
        } else {
            lastUpdateText = nil
        }
    }

    private func updateRainWarning() {
        // Якщо користувач вимкнув попередження – очищаємо і виходимо
        guard AppSettings.shared.isRainAlertEnabled else {
            rainWarning = nil
            return
        }

        guard let hourly = weatherResult?.hourly else {
            rainWarning = nil
            return
        }

        let now = Date()
        let threshold = AppSettings.shared.rainThreshold.rawValue

        // time і precipitation синхронні за індексом
        for (index, amount) in hourly.precipitation.enumerated() {
            // шукаємо перший час, коли опади > порога
            guard amount > threshold else { continue }

            let timeString = hourly.time[index]
            guard let date = DateFormatterService.date(from: timeString) else { continue }
            guard date > now else { continue } // пропускаємо те, що вже у минулому

            if let intervalString = DateFormatterService.timeIntervalString(from: now, to: date) {
                // DateComponentsFormatter форматує тільки тривалість,
                // тому «через» додаємо вручну
                rainWarning = "Дощ очікується через \(intervalString)"
            } else {
                rainWarning = nil
            }

            return
        }

        // якщо в найближчих годинах опадів немає
        rainWarning = "У найближчий час дощу не очікується"
    }
}

