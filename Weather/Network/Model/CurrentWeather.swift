//
//  CurrentWeather.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import Foundation

struct CurrentWeather: Decodable {
    let coord: Location
    let weather: [Weather]
    let temp: Temperature
    let wind : Wind
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case temp = "main"
        case wind
        case name
    }
}

struct Location: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
    let description: String
    let icon: String
    
    var iconURL: URL? {
        let urlString = "https://openweathermap.org/img/wn/\(icon)@2x.png"
        guard let url = URL(string: urlString) else { return nil }
        return url
    }
}

struct Temperature: Decodable {
    let temp: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int
    let humidity: Int
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
    
    var convertedTemp: Double {
        return temp - 273.15
    }
    
    var convertedMinTemp: Double {
        return tempMin - 273.15
    }
    
    var convertedMaxTemp: Double {
        return tempMax - 273.15
    }
    
    var convertedMinMaxTemp: String {
        let maxTempString = String(format: "%.1f", convertedMaxTemp)
        let minTempString = String(format: "%.1f", convertedMinTemp)
        return "최고:\(maxTempString)° | 최저:\(minTempString)°"
    }
    
    var currentTempString: String {
        let result = String(format: "%.1f", convertedTemp)
        return "\(result)°"
    }
    
    var regularHoursTempString: String {
        let result = Int(convertedTemp)
        return "\(result)°"
    }
}

struct Wind: Decodable {
    let speed: Double
}
