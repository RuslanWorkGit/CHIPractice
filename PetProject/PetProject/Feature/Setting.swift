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

enum RainThreshold: Double, CaseIterable, Identifiable {
    case low    = 0.1
    case medium = 0.5
    case high   = 1.0

    var id: Double { rawValue }

    var title: String {
        switch self {
        case .low:    return "0.1 mm"
        case .medium: return "0.5 mm"
        case .high:   return "1.0 mm"
        }
    }
}

enum WindSpeedUnit: String, Codable, CaseIterable {
    case kilometersPerHour
    case metersPerSecond

    var title: String {
        switch self {
        case .kilometersPerHour: return "km/hour"
        case .metersPerSecond:   return "m/s"
        }
    }
}

final class AppSettings {
    static let shared = AppSettings()
    private init() {}

    private let defaults = UserDefaults.standard

    private enum Keys {
        static let temperatureUnit   = "settings.temperatureUnit"
        static let lastLatitude      = "settings.lastLatitude"
        static let lastLongitude     = "settings.lastLongitude"
        static let lastUpdateDate    = "settings.lastUpdateDate"

        static let rainThreshold     = "settings.rainThreshold"
        static let isRainAlertOn     = "settings.isRainAlertOn"
        static let windSpeedUnit     = "settings.windSpeedUnit"
    }

    // MARK: - Температура
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

    // MARK: - для дощу
    var rainThreshold: RainThreshold {
        get {
            guard defaults.object(forKey: Keys.rainThreshold) != nil else {
                return .low
            }
            let value = defaults.double(forKey: Keys.rainThreshold)
            return RainThreshold(rawValue: value) ?? .low
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.rainThreshold)
        }
    }

    var isRainAlertEnabled: Bool {
        get {
            // За замовчуванням попередження вмикаємо
            guard defaults.object(forKey: Keys.isRainAlertOn) != nil else {
                return true
            }
            return defaults.bool(forKey: Keys.isRainAlertOn)
        }
        set {
            defaults.set(newValue, forKey: Keys.isRainAlertOn)
        }
    }

    // MARK: - Wind
    var windSpeedUnit: WindSpeedUnit {
        get {
            if let raw = defaults.string(forKey: Keys.windSpeedUnit),
               let value = WindSpeedUnit(rawValue: raw) {
                return value
            }
            return .kilometersPerHour
        }
        set {
            defaults.set(newValue.rawValue, forKey: Keys.windSpeedUnit)
        }
    }

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

    // MARK: - Last updates
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


