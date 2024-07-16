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
    
    //typealias CompletionHandler<T: Decodable> = (T?, String?) -> Void
    
    func fetchWeatherData<T: Decodable>(urlCase: URLRequestCase, _ completionHandler: @escaping (Result<T, Error>) -> Void)  {
        guard let url = urlCase.endPoint else { return }
        let parmas = urlCase.params

        AF.request(url, method: urlCase.method, parameters: parmas).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(.success(value))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
}

extension NetworkService: NetworkProtocol {
    func fetchHoursWeather(id: String, completionHandler: @escaping (Result<RegularWeatherContainer, any Error>) -> Void) {
        fetchWeatherData(urlCase: .regularWeather(id: id), completionHandler)
    }
    
    func fetchDaysWeather(id: String, completionHandler: @escaping (Result<RegularWeatherContainer, any Error>) -> Void) {
        fetchWeatherData(urlCase: .regularWeather(id: id), completionHandler)
    }
    
    func fetchCurrentWeather(id: String, completionHandler: @escaping (Result<CurrentWeather, any Error>) -> Void) {
        fetchWeatherData(urlCase: .nowWeather(id: id), completionHandler)
    }
}
