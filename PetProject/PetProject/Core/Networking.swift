//
//  Networking.swift
//  PetProject
//
//  Created by user on 26.11.2025.
//
import Foundation

enum WeatherEndpoint {
    case forecast(latitude: Double, longitude: Double)
}

enum WeatherAPIError: Error {
    case invalidStatusCode(Int)
    case decodingFailed(Error)
}

extension WeatherEndpoint {
    
    private var baseURL: URL {
        URL(string: "https://api.open-meteo.com")!
    }
    
    private var path: String {
        switch self {
        case .forecast:
            return "/v1/forecast"
        }
    }
    
    //parameters
    private var queryItems: [URLQueryItem] {
        switch self {
        case let .forecast(latitude, longitude):
            return [
                URLQueryItem(name: "latitude", value: String(latitude)),
                URLQueryItem(name: "longitude", value: String(longitude)),
                
                URLQueryItem(name: "hourly", value: "temperature_2m,relativehumidity_2m,precipitation"),
                URLQueryItem(name: "daily", value: "temperature_2m_max,temperature_2m_min"),
                URLQueryItem(name: "timezone", value: "auto")
            ]
        }
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = baseURL.scheme
        components.host = baseURL.host
        components.path = path
        components.queryItems = queryItems
        
        guard let url = components.url else {
            preconditionFailure("Wrong URL \(self)")
        }
        return url
    }
}

protocol WeatherAPIClientProtocol {
    func fetchForecast(latitude: Double, longitude: Double) async throws -> WeatherForecastResponse
}

final class WeatherAPIClient {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchForecast(latitude: Double, longitude: Double) async throws -> WeatherForecastResponse {
        let endPoint = WeatherEndpoint.forecast(latitude: latitude, longitude: longitude)
        
        let url = endPoint.url
        
        let (data, response) = try await session.data(from: url)
        
        if let htttpResponse = response as? HTTPURLResponse, !(200...299).contains(htttpResponse.statusCode) {
            throw WeatherAPIError.invalidStatusCode(htttpResponse.statusCode)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            
            let forecast = try decoder.decode(WeatherForecastResponse.self, from: data)
            return forecast
        } catch {
            if let decodingError = error as? DecodingError {
                    print("❌ DecodingError:", decodingError)
                } else {
                    print("❌ Other error:", error)
                }
            throw WeatherAPIError.decodingFailed(error)
        }
    }
}
