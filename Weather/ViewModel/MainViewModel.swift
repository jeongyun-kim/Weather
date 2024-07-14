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
    var getCityData: Observable<City?> = Observable(nil)
    
    // Output
    // Header 내 들어갈 날씨 데이터
    var headerWeather: Observable<CurrentWeather?> = Observable(nil)
    // 3시간 간격의 일기예보 데이터
    var regularHoursWeathers: Observable<[ListData]> = Observable([])
    // 5일간의 일기예보 데이터
    var weatherForFiveDays: Observable<[RegularDaysWeather]> = Observable([])
    // 테이블뷰 맨마지막칸의 날씨 정보로 사용할 데이터
    var weatherInfoArr: Observable<[[String]]> = Observable([["","",""], ["","",""], ["","",""], ["","",""]])
    // 네트워크 통신이 끝났음을 알림 -> TableView Reload
    var endedRequestTrigger: Observable<Void?> = Observable(nil)
    // 네트워크 도중 에러가 생긴다면 에러 메시지 담아줄 변수 
    var errorMessage: Observable<String?> = Observable(nil)
    
    init() {
        fetchWeather()
    }
    
    // 날씨에 관한 네트워크 통신
    private func fetchWeather() {
        viewWillLoadTrigger.bind { _ in
            // UserDefaults에 저장된 날씨 아이디를 기준으로 통신
            let weatherId = self.ud.weatherId
            let group = DispatchGroup()
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchCurrentWeather(id: weatherId) { weather, errorMessage in
                    if let errorMessage {
                        self.errorMessage.value = errorMessage
                    } else {
                        guard let weather else { return }
                        // 헤더에 사용할 정보보내기
                        self.headerWeather.value = weather
                        self.makeWeatherInfoArr(weather)
                    }
                    group.leave()
                }
            }
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchHoursWeather(id: weatherId) { weather, errorMessage in
                    if let errorMessage {
                        self.errorMessage.value = errorMessage
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
                        self.errorMessage.value = errorMessage
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
    
    // 5일간의 일기예보 구성
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
    
    // 그 외 정보 구성
    private func makeWeatherInfoArr(_ data: CurrentWeather) {
        // 그 외 정보에 사용할 배열로 내보내기
        let infos = Resource.InfoCellCase.allCases
        let wind = "\(data.wind.speed)m/s"
        let cloud = "\(data.clouds.all)%"
        let pressure = "\(data.temp.pressure)hpa"
        let humidity = "\(data.temp.humidity)%"
        let infoArr = [wind, cloud, pressure, humidity]

        for i in 0..<infos.count {
            let title = infos[i].rawValue
            let imageName = infos[i].imageName
            let info = infoArr[i]
            
            self.weatherInfoArr.value[i] = [title, imageName, info]
        }
    }
}


