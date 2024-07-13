//
//  URLRequestCase.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//
import Foundation
import Alamofire

enum URLRequestCase {
    case nowWeather(id: String)
    case regularWeather(id: String)
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/2.5/"
    }
    
    var endPoint: URL? {
        switch self {
        case .nowWeather:
            guard let url = URL(string: baseURL + "weather") else { return nil }
            return url
        case .regularWeather:
            guard let url = URL(string: baseURL + "forecast") else { return nil }
            return url
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: Parameters {
        switch self {
        case .nowWeather(let id), .regularWeather(let id):
            return ["id": id, "appid": APIKey.key, "lang": "kr"]
        }
    }
}
