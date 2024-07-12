//
//  NetworkProtocol.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import Foundation

protocol NetworkProtocol {
    func fetchCurrentWeather(id: String, completionHandler: @escaping (CurrentWeather?, String?) -> Void)
    func fetchWeatherRegularly(id: String, completionHandler: @escaping (RegularWeatherContainer?, String?) -> Void)
}
