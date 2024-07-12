//
//  NetworkProtocol.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import Foundation

protocol NetworkProtocol {
    func fetchCurrentWeather(id: String, completionHandler: @escaping (CurrentWeather?, String?) -> Void)
    func fetchHoursWeather(id: String, completionHandler: @escaping (RegularWeatherContainer?, String?) -> Void)
    func fetchDaysWeather(id: String, completionHandler: @escaping (RegularWeatherContainer?, String?) -> Void)
}
