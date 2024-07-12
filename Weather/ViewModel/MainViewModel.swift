//
//  MainViewModel.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import Foundation

final class MainViewModel {
    private let ud = UserDefaultsManager.shared
    
    // Input
    // MainVC 진입 시마다 신호받기
    var viewWillLoadTrigger: Observable<Void?> = Observable(nil)
    
    // Output
    // Header 내 들어갈 날씨 데이터
    var headerWeather: Observable<CurrentWeather?> = Observable(nil)
    // 3시간 간격의 일기예보 데이터
    var regularHoursWeathers: Observable<[ListData]> = Observable([])
    // 5일간의 일기예보 데이터
    var weatherForFiveDays: Observable<[RegularDaysWeather]> = Observable([])
    // 네트워크 통신이 끝났음을 알림 -> TableView Reload
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
                NetworkService.shared.fetchHoursWeather(id: weatherId) { weather, errorMessage in
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
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchDaysWeather(id: weatherId) { weather, errorMessage in
                    if let errorMessage {
                        print(errorMessage)
                    } else {
                        guard let weather else { return }
                        let weatherList = weather.list
                        self.getRegularDaysWeatherArr(weatherList)
                    }
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.endedRequestTrigger.value = ()
            }
        }
    }
    
    private func getRegularDaysWeatherArr(_ list: [ListData]) {
        var dailyWeatherArr: [RegularDaysWeather] = []
        
        for i in stride(from: 0, to: list.count, by: 8) {
            // 저장할 모델 생성
            var weather = RegularDaysWeather(date: "", iconURL: nil, tempMin: "", tempMax: "")
            // 5일간의 데이터 중에서 각 날짜별 최저/최고기온 구하기
            let minTemp = list[i...i+7].map { $0.temp.convertedMinTemp }.min()
            let maxTemp = list[i...i+7].map { $0.temp.convertedMaxTemp }.max()
            
            // 첫번째 데이터면 오늘
            if i == 0 {
                weather.date = "오늘"
            } else { // 그 외는 내일모레...
                weather.date = list[i].date // 각 날짜 저장
            }
            
            // 최저/최고기온 Int로 변경해 소수점 제거한 후 String으로 저장
            if let minTemp, let maxTemp, let weatherData = list[i+2].weather.first {
                let intMinTemp = Int(minTemp)
                let intMaxTemp = Int(maxTemp)
                weather.tempMin = "\(intMinTemp)°"
                weather.tempMax = "\(intMaxTemp)°"
                
                weather.iconURL = weatherData.iconURL
            }
            dailyWeatherArr.append(weather)
        }
        
        self.weatherForFiveDays.value = dailyWeatherArr
    }
}


