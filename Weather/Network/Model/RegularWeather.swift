//
//  RegularWeather.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import Foundation

struct RegularWeatherContainer: Decodable {
    let cod: String
    let message: Int
    let cnt: Int
    let list: [ListData]
    
}

struct ListData: Decodable {
    let main: Temperature
    let weather: [Weather]
    let dt_txt: String
}
//"cod": "200",
//  "message": 0,
//  "cnt": 40,
//  "list": [
//    {
//      "dt": 1661871600,
//      "main": {
//        "temp": 296.76,
//        "feels_like": 296.98,
//        "temp_min": 296.76,
//        "temp_max": 297.87,
//        "pressure": 1015,
//        "sea_level": 1015,
//        "grnd_level": 933,
//        "humidity": 69,
//        "temp_kf": -1.11
//      },
//      "weather": [
//        {
//          "id": 500,
//          "main": "Rain",
//          "description": "light rain",
//          "icon": "10d"
//        }
//      ],
//      "clouds": {
//        "all": 100
//      },
//      "wind": {
//        "speed": 0.62,
//        "deg": 349,
//        "gust": 1.18
//      },
//      "visibility": 10000,
//      "pop": 0.32,
//      "rain": {
//        "3h": 0.26
//      },
//      "sys": {
//        "pod": "d"
//      },
//      "dt_txt": "2022-08-30 15:00:00"
//    },
