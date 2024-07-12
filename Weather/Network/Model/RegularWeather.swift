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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        guard let newDate = dateFormatter.date(from: date) else { return "" }
        dateFormatter.dateFormat = "HH시"
        let result = dateFormatter.string(from: newDate)
        return result
    }
}
