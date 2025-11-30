//
//  Setting.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//


import Foundation

enum TemperatureUnit: String, Codable, CaseIterable {
    case celsius
    case fahrenheit
}

final class AppSettings {
    static let shared = AppSettings()
    private init() {}
    
    private let defaults = UserDefaults.standard
    
    private enum Keys {
        static let temperatureUnit = "settings.temperatureUnit"
        static let lastLatitude    = "settings.lastLatitude"
        static let lastLongitude   = "settings.lastLongitude"
        static let lastUpdateDate  = "settings.lastUpdateDate"
    }
    
    // Одиниці вимірювання температури
    var temperatureUnit: TemperatureUnit {
        get {
            if let raw = defaults.string(forKey: Keys.temperatureUnit),
               let value = TemperatureUnit(rawValue: raw) {
                return value
            }
            return .celsius
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.temperatureUnit)
        }
    }
    
    // Збереження / отримання останньої локації
    func saveLastLocation(latitude: Double, longitude: Double) {
        defaults.set(latitude, forKey: Keys.lastLatitude)
        defaults.set(longitude, forKey: Keys.lastLongitude)
    }
    
    func lastLocation() -> (lat: Double, lon: Double)? {
        let lat = defaults.double(forKey: Keys.lastLatitude)
        let lon = defaults.double(forKey: Keys.lastLongitude)
        
        if lat == 0 && lon == 0 { return nil }
        return (lat, lon)
    }
    
    // Останній час оновлення
    var lastUpdateDate: Date? {
        get {
            if let timeInterval = defaults.object(forKey: Keys.lastUpdateDate) as? TimeInterval {
                return Date(timeIntervalSince1970: timeInterval)
            }
            return nil
        }
        set {
            if let date = newValue {
                defaults.set(date.timeIntervalSince1970, forKey: Keys.lastUpdateDate)
            } else {
                defaults.removeObject(forKey: Keys.lastUpdateDate)
            }
        }
    }
}
