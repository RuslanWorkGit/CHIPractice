//
//  FirstViewModel.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//

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

        // Kyiv
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

        for (index, amount) in hourly.precipitation.enumerated() {
            guard amount > threshold else { continue }

            let timeString = hourly.time[index]
            guard let date = DateFormatterService.date(from: timeString) else { continue }
            guard date > now else { continue } // пропускаємо те, що вже у минулому

            if let intervalString = DateFormatterService.timeIntervalString(from: now, to: date) {
                rainWarning = "Rain is expected due to \(intervalString)"
            } else {
                rainWarning = nil
            }

            return
        }

        // якщо в найближчих годинах опадів немає
        rainWarning = "No rain is expected in the near future."
    }
}

