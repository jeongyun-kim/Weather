//
//  MainViewModel.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import Foundation

final class MainViewModel {
    private let monitor = NetworkMonitoringManager.shared
    private let ud = UserDefaultsManager.shared
    
    // Input
    // MainVC 진입 시마다 신호받기
    var viewWillLoadTrigger: Observable<Void?> = Observable(nil)
    var inputCityData: Observable<City?> = Observable(nil)

    // Output
    // Header 내 들어갈 날씨 데이터
    var headerWeather: Observable<CurrentWeather?> = Observable(nil)
    // 3시간 간격의 일기예보 데이터
    var regularHoursWeathers: Observable<[ListData]> = Observable([])
    // 5일간의 일기예보 데이터
    var weatherForFiveDays: Observable<[RegularDaysWeather]> = Observable([])
    // 위치 정보 데이터
    var outputLocation: Observable<Location?> = Observable(nil)
    // 테이블뷰 맨마지막칸의 날씨 정보로 사용할 데이터
    var weatherInfoArr: Observable<[[String: String]]> = Observable([[:], [:], [:], [:]])
    // 네트워크 통신이 끝났음을 알림 -> TableView Reload
    var endedRequestTrigger: Observable<Void?> = Observable(nil)
    // 날씨 정보 받아올 때 에러가 생긴다면 에러 메시지 담아주기 
    var weatherErrorMessage: Observable<String?> = Observable(nil)
    // 네트워크 상태 확인해서 네트워크 연결이 끊긴다면 에러 메시지 담아주기
    var networkErrorMessage: Observable<String?> = Observable(nil)
    
    init() {
        fetchWeather()
        saveCityData()
        // 5초에 한 번씩 네트워크 연결 확인하기
        Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(networkMonitoring), userInfo: nil, repeats: true)
    }
    
    @objc private func networkMonitoring() {
        if self.monitor.isConnected {
            self.networkErrorMessage.value = nil
        } else { // 현재 네트워크 연결이 없다면 에러 메시지 보내기 
            self.networkErrorMessage.value = "네트워크를 확인해주세요"
        }
    }
    
    private func saveCityData() {
        inputCityData.bind { city in
            guard let city else { return }
            // 도시가 새로 선택되면 UserDefaults에 저장되어있는 도시ID 변경
            self.ud.weatherId = "\(city.id)"
        }
    }
    
    // 날씨에 관한 네트워크 통신
    private func fetchWeather() {
        print(#function)
        viewWillLoadTrigger.bind { _ in
            // 네트워크 통신 이전에 에러메시지 비워주기
            self.weatherErrorMessage.value = nil
            // UserDefaults에 저장된 날씨 아이디를 기준으로 통신
            let weatherId = self.ud.weatherId
            let group = DispatchGroup()
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchCurrentWeather(id: weatherId) { response in
                    switch response {
                    case .success(let weather):
                        // 헤더에 사용할 정보보내기
                        self.headerWeather.value = weather
                        self.makeWeatherInfoArr(weather)
                        self.outputLocation.value = weather.coord
                    case .failure(let failure):
                        self.weatherErrorMessage.value = Resource.ErrorMessage.weatherError.rawValue
                    }
                    group.leave()
                }
            }
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchHoursWeather(id: weatherId) { response in
                    switch response {
                    case .success(let weather):
                        let newList = Array(weather.list.prefix(24))
                        self.regularHoursWeathers.value = newList
                    case .failure(let failure):
                        self.weatherErrorMessage.value = Resource.ErrorMessage.weatherError.rawValue
                    }
                    group.leave()
                }
            }
            
            group.enter()
            DispatchQueue.global().async(group: group) {
                NetworkService.shared.fetchDaysWeather(id: weatherId) { response in
                    switch response {
                    case .success(let weather):
                        let weatherList = weather.list
                        self.getRegularDaysWeatherArr(weatherList)
                    case .failure(let failure):
                        self.weatherErrorMessage.value = Resource.ErrorMessage.weatherError.rawValue
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
    // 5일간의 데이터 중에서 각 날짜별 최저/최고기온 구하기
    // 현재 네트워크를 통신하는 시점 -6시간 전 데이터부터 가르쳐줌
    // 즉, 8개씩 잘라서 보여주면 오늘 날씨가 아니라 오늘내일 날씨가 섞여서 나올수도 있음을 의미
    // => 현재 시점을 기준으로 그냥 각 날짜별 첫번째 데이터를 key로 한 딕셔너리 구성해서 values만 보내주기
    private func getRegularDaysWeatherArr(_ list: [ListData]) {
        var dailyWeatherDic: [String: RegularDaysWeather] = [:]
        
        for i in 0..<list.count {
            let data = list[i]
            // yyyy-MM-dd HH:mm:ss에서 yyyy-MM-dd만 가져와서 각 날짜별로 하나씩만
            let key = data.date.components(separatedBy: " ")[0]
            if let weather = data.weather.first, !dailyWeatherDic.keys.contains(key) {
                let minTemp = "\(Int(data.temp.convertedMinTemp))°"
                let maxTemp = "\(Int(data.temp.convertedMaxTemp))°"
                dailyWeatherDic[key] = RegularDaysWeather(date: data.date, iconURL: weather.iconURL, tempMin: minTemp, tempMax: maxTemp)
            }
        }

        // 날짜순으로 정렬
        // 간혹 오늘 포함 6일치가 오는 경우가 있음 -> 5일치만 받아오게 앞에서 5개로 잘라주기
        let dicValues = dailyWeatherDic.values.sorted(by: { $0.date < $1.date }).prefix(5)
        var dicValuesArr = Array(dicValues)
        // 첫번째 데이터 = 오늘
        dicValuesArr[0].date = "오늘"
        
        self.weatherForFiveDays.value = dicValuesArr
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
            let infoType = infos[i].rawValue
            let infoImage = infos[i].imageName
            let info = infoArr[i]
            
            self.weatherInfoArr.value[i] = ["infoType": infoType, "infoImage": infoImage, "info": info]
        }
    }
}


