//
//  MainViewModel.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import Foundation

final class MainViewModel {
    
    var viewWillLoadTrigger: Observable<Void?> = Observable(nil)
    var headerWeather: Observable<CurrentWeather?> = Observable(nil)

    init() {
        fetchWeather()
    }
    
    private func fetchWeather() {
        viewWillLoadTrigger.bind { _ in
            let group = DispatchGroup()
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchCurrentWeather(id: "1835847") { weather, errorMessage in
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
                NetworkService.shared.fetchWeatherRegularly(id: "1835847") { weather, errorMessage in
                    if let errorMessage {
                        print(errorMessage)
                    } else {
                        guard let weather else { return }
                        print(weather)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                print("end!")
            }
        }
    }
    
    private func fetchRegularWeather() {
        
    }
   
}
