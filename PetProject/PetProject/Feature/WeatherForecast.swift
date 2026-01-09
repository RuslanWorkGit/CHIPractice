//
//  WeatherForecast.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//

import Foundation

struct CachedForecast: Codable {
    let forecast: WeatherForecastResponse
    let savedAt: Date
}

final class WeatherStorage {
    static let shared = WeatherStorage()
    private init() {}
    
    private let fileManager = FileManager.default
    
    private var cacheURL: URL {
        let directory = fileManager.urls(for: .cachesDirectory, in: .userDomainMask).first!
        return directory.appendingPathComponent("forecast_cache.json")
    }
    
    func saveForecast(_ forecast: WeatherForecastResponse) {
        let cached = CachedForecast(forecast: forecast, savedAt: Date())
        
        do {
            let data = try JSONEncoder().encode(cached)
            try data.write(to: cacheURL, options: [.atomic])
        } catch {
            print("Failed to save forecast:", error)
        }
    }
    
    func loadForecast() -> CachedForecast? {
        guard fileManager.fileExists(atPath: cacheURL.path) else { return nil }
        
        do {
            let data = try Data(contentsOf: cacheURL)
            let cached = try JSONDecoder().decode(CachedForecast.self, from: data)
            return cached
        } catch {
            print("Failed to load forecast:", error)
            return nil
        }
    }
    
    func clearForecast() {
        try? fileManager.removeItem(at: cacheURL)
    }
}
