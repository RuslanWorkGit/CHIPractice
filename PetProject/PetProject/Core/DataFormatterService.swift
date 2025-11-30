//
//  DataFormatterService.swift
//  PetProject
//
//  Created by user on 27.11.2025.
//

//import Foundation
//
//enum DateFormatterService {
//    
//    //"2025-11-26T00:00"
//    private static let inputFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
//        formatter.locale = Locale(identifier: "en_US_POSIX")
//        formatter.timeZone = .current
//        return formatter
//    }()
//    
//    private static let outputTimeFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateFormat = "HH:mm"
//        formatter.locale = .current
//        formatter.timeZone = .current
//        return formatter
//    }()
//    
//    private static let outputTimeDateFormatter: DateFormatter = {
//        let formatter = DateFormatter()
//        formatter.dateStyle = .medium
//        formatter.timeStyle = .short
//        formatter.locale = .current
//        formatter.timeZone = .current
//        return formatter
//    }()
//    
//    // MARK: - Temperature
//    
//    private static let temperatureFormatter: MeasurementFormatter = {
//        let formatter = MeasurementFormatter()
//        formatter.locale = .current
//        formatter.numberFormatter.maximumFractionDigits = 0
//        formatter.unitOptions = .providedUnit
//        return formatter
//    }()
//    
//    static func formattedTemperature(_ celsius: Double, unit: TemperatureUnit) -> String {
//        let measurement: Measurement<UnitTemperature>
//        
//        switch unit {
//        case .celsius:
//            measurement = Measurement(value: celsius, unit: .celsius)
//        case .fahrenheit:
//            measurement = Measurement(value: celsius, unit: .celsius).converted(to: .fahrenheit)
//        }
//        
//        return temperatureFormatter.string(from: measurement)
//    }
//    
//    // MARK: - Relative date
//    
//    static func formattedRelativeDate(from date: Date) -> String {
//        let formatter = RelativeDateTimeFormatter()
//        formatter.locale = .current
//        return formatter.localizedString(for: date, relativeTo: Date())
//    }
//    
//    static func formatedHour(from timeString: String) -> String {
//        guard let date = inputFormatter.date(from: timeString) else {
//            return timeString
//        }
//        return outputTimeFormatter.string(from: date)
//    }
//    
//    static func formatedDate(from dateString: String) -> String {
//        guard let date = inputFormatter.date(from: dateString) else {
//            return dateString
//        }
//        return outputTimeDateFormatter.string(from: date)
//    }
//    
//    // MARK: - Interval formatter для "3 години 15 хвилин"
//    
//    private static let intervalFormatter: DateComponentsFormatter = {
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.hour, .minute]
//        formatter.unitsStyle = .full      // "3 hours, 15 minutes"
//        formatter.maximumUnitCount = 2
//        return formatter
//    }()
//    
//    /// Повертаємо Date з API-рядка "yyyy-MM-dd'T'HH:mm"
//    static func date(from timeString: String) -> Date? {
//        return inputFormatter.date(from: timeString)
//    }
//    
//    /// Форматуємо інтервал між двома датами в людинозрозумілу строку
//    static func timeIntervalString(from start: Date, to end: Date) -> String? {
//        let interval = end.timeIntervalSince(start)
//        guard interval > 0 else { return nil }
//        return intervalFormatter.string(from: interval)
//    }
//    
//}

import Foundation

enum DateFormatterService {

    //"2025-11-26T00:00"
    private static let inputFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = .current
        return formatter
    }()

    private static let outputTimeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }()

    private static let outputTimeDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        formatter.locale = .current
        formatter.timeZone = .current
        return formatter
    }()

    // MARK: - Temperature

    private static let temperatureFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.locale = .current
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        return formatter
    }()

    static func formattedTemperature(_ celsius: Double, unit: TemperatureUnit) -> String {
        let measurement: Measurement<UnitTemperature>

        switch unit {
        case .celsius:
            measurement = Measurement(value: celsius, unit: .celsius)
        case .fahrenheit:
            measurement = Measurement(value: celsius, unit: .celsius).converted(to: .fahrenheit)
        }

        return temperatureFormatter.string(from: measurement)
    }

    // MARK: - Wind speed

    private static let windSpeedFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.locale = .current
        formatter.numberFormatter.maximumFractionDigits = 0
        formatter.unitOptions = .providedUnit
        return formatter
    }()

    /// valueInKilometersPerHour – швидкість у км/год
    /// (Open-Meteo за замовчуванням віддає вітер у km/h, тому це зручно підходить під їх API)
    static func formattedWindSpeed(_ valueInKilometersPerHour: Double,
                                   unit: WindSpeedUnit) -> String {
        let base = Measurement(value: valueInKilometersPerHour,
                               unit: UnitSpeed.kilometersPerHour)

        let converted: Measurement<UnitSpeed>
        switch unit {
        case .kilometersPerHour:
            converted = base
        case .metersPerSecond:
            converted = base.converted(to: .metersPerSecond)
        }

        return windSpeedFormatter.string(from: converted)
    }

    // MARK: - Relative date

    static func formattedRelativeDate(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.locale = .current
        return formatter.localizedString(for: date, relativeTo: Date())
    }

    static func formatedHour(from timeString: String) -> String {
        guard let date = inputFormatter.date(from: timeString) else {
            return timeString
        }
        return outputTimeFormatter.string(from: date)
    }

    static func formatedDate(from dateString: String) -> String {
        guard let date = inputFormatter.date(from: dateString) else {
            return dateString
        }
        return outputTimeDateFormatter.string(from: date)
    }

    // MARK: - Interval formatter для "3 години 15 хвилин"

    private static let intervalFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 2
        return formatter
    }()

    /// Повертаємо Date з API-рядка "yyyy-MM-dd'T'HH:mm"
    static func date(from timeString: String) -> Date? {
        return inputFormatter.date(from: timeString)
    }

    /// Форматуємо інтервал між двома датами в людинозрозумілу строку
    static func timeIntervalString(from start: Date, to end: Date) -> String? {
        let interval = end.timeIntervalSince(start)
        guard interval > 0 else { return nil }
        return intervalFormatter.string(from: interval)
    }
}
