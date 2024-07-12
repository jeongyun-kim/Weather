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
    let temp: Temperature
    let weather: [Weather]
    let date: String
    
    enum CodingKeys: String, CodingKey {
        case temp = "main"
        case weather
        case date = "dt_txt"
    }
    
    var formattedDate: String {
        let result = DateFormatterManager.shared.dateToString(date)
        return result
    }
}
