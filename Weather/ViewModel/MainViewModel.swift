//
//  MainViewModel.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import Foundation

final class MainViewModel {
    private let ud = UserDefaultsManager.shared
    
    var viewWillLoadTrigger: Observable<Void?> = Observable(nil)
    
    var headerWeather: Observable<CurrentWeather?> = Observable(nil)
    var regularHoursWeathers: Observable<[ListData]> = Observable([])
    var endedRequestTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        fetchWeather()
    }
    
    private func fetchWeather() {
        viewWillLoadTrigger.bind { _ in
            let weatherId = self.ud.weatherId
            let group = DispatchGroup()
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchCurrentWeather(id: weatherId) { weather, errorMessage in
                    if let errorMessage {
                        print(errorMessage)
                    } else {
                        guard let weather else { return }
                        self.headerWeather.value = weather
                    }
                    group.leave()
                }
            }
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchWeatherRegularly(id: weatherId) { weather, errorMessage in
                    if let errorMessage {
                        print(errorMessage)
                    } else {
                        guard let weather else { return }
                        let newList = Array(weather.list.prefix(24))
                        self.regularHoursWeathers.value = newList
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.endedRequestTrigger.value = ()
            }
        }
    }
    
    private func fetchRegularWeather() {
        
    }
   
}
