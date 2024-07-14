//
//  NetworkService.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import Foundation
import Alamofire

final class NetworkService {
    private init() { }
    static let shared = NetworkService()
    
    typealias CompletionHandler<T: Decodable> = (T?, String?) -> Void
    
    func fetchWeatherData<T: Decodable>(urlCase: URLRequestCase, _ completionHandler: @escaping CompletionHandler<T>)  {
        guard let url = urlCase.endPoint else { return }
        let parmas = urlCase.params

        AF.request(url, method: urlCase.method, parameters: parmas).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(let error):
                completionHandler(nil, "날씨 정보를 불러올 수 없습니다🥲")
            }
        }
    }
}

extension NetworkService: NetworkProtocol {
    func fetchCurrentWeather(id: String, completionHandler: @escaping (CurrentWeather?, String?) -> Void) {
        fetchWeatherData(urlCase: .nowWeather(id: id), completionHandler)
    }
    
    func fetchHoursWeather(id: String, completionHandler: @escaping (RegularWeatherContainer?, String?) -> Void) {
        fetchWeatherData(urlCase: .regularWeather(id: id), completionHandler)
    }
    
    func fetchDaysWeather(id: String, completionHandler: @escaping (RegularWeatherContainer?, String?) -> Void) {
        fetchWeatherData(urlCase: .regularWeather(id: id), completionHandler)
    }
}
