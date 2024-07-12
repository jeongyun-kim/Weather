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
    let main: Temperature
    let wind : Wind
}

struct Location: Decodable {
    let lon: Double
    let lat: Double
}

struct Weather: Decodable {
    let id: Int
    let icon: String
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
}

struct Wind: Decodable {
    let speed: Double
}
//
//{"coord":{"lon":126.5219,"lat":33.5097},
//    "weather":[{"id":803,"main":"Clouds","description":"broken clouds","icon":"04n"}],
//    "base":"stations",
//    "main":{"temp":296.11,"feels_like":296.92,"temp_min":296.11,"temp_max":296.11,"pressure":1004,"humidity":94,"sea_level":1004,"grnd_level":1001},
//    "visibility":7000,
//    "wind":{"speed":1.54,"deg":250},
//    "rain":{"1h":0.1},"clouds":{"all":75},"dt":1720705628,"sys":{"type":1,"id":8087,"country":"KR","sunrise":1720643541,"sunset":1720694762},"timezone":32400,"id":1846266,"name":"Jeju City","cod":200}
