//
//  NetworkProtocol.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import Foundation

protocol NetworkProtocol {
    func fetchCurrentWeather(id: String, completionHandler: @escaping (Result<CurrentWeather, Error>) -> Void)
    func fetchHoursWeather(id: String, completionHandler: @escaping (Result<RegularWeatherContainer, Error>) -> Void)
    func fetchDaysWeather(id: String, completionHandler: @escaping (Result<RegularWeatherContainer, Error>) -> Void)
}
