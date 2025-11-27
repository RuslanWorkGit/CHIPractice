//
//  Models.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//

import Foundation

struct WeatherForecastResponse: Codable {
    
    // TODO: додати поля з потрібними значеннями
    
    let latitude: Double
    let longitude: Double
    let generationtimeMs: Double
    let timezone: String
    let hourly: Hourly
    
    enum CodingKeys: String, CodingKey {
        case latitude
        case longitude
        case generationtimeMs = "generationtime_ms"
        case timezone
        case hourly
    }
}

struct Hourly: Codable {
    let time: [String]
    let temperature2m: [Double]
    let relativeHumidity2m: [Int]
    let precipitation: [Double]
    
    enum CodingKeys: String, CodingKey {
        case time
        case temperature2m       = "temperature_2m"       // temperature_2m -> temperature2m
        case relativeHumidity2m  = "relativehumidity_2m"  // relativehumidity_2m -> relativehumidity2m
        case precipitation
    }
}
