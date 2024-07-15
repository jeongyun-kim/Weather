//
//  CityListViewModel.swift
//  Weather
//
//  Created by 김정윤 on 7/13/24.
//

import Foundation

final class CityListViewModel {
    private let ud = UserDefaultsManager.shared
    
    // Input
    // CityListVC 진입 시 신호받기
    var viewDidLoadTrigger: Observable<Void?> = Observable(nil)
    // 사용자가 현재 선택한 도시 정보
    var selectedCity: Observable<City?> = Observable(nil)
    // 사용자가 서치바에 키워드 입력할 때마다 활성화
    var searchedKeyword: Observable<String> = Observable("")
    
    // Output
    // CityList.json 파싱 후 항상 가지고 있을 원본 CityList
    var originalCityList: [City] = []
    // CityListVC로 내보낼 리스트
    var outputCityListResult: Observable<(String?, [City]?)> = Observable((nil, []))
    // 사용자가 도시 선택 시, 뒤로가기 신호받기
    var viewWillDisappearTrigger: Observable<Void?> = Observable(nil)

    init() {
        transform()
    }
    
    private func transform() {
        viewDidLoadTrigger.bind { _ in
            self.parsingCityList()
        }
        
        selectedCity.bind { city in
            guard let city else { return }
            // 뒤로가기 신호보내기
            self.viewWillDisappearTrigger.value = ()
        }
        
        searchedKeyword.bind { keyword in
            if !keyword.isEmpty { // 서치바가 비워있지 않다면 도시명에 해당 키워드가 포함된 결과 내보내기
                let searchedList = self.originalCityList.filter { city in
                    city.name.contains(keyword)
                }
                self.outputCityListResult.value = (nil, searchedList)
            } else { // 서치바가 비어있다면 원본데이터로 다시 결과 바꿔주기
                self.outputCityListResult.value = (nil, self.originalCityList)
            }
        }
    }
    
    private func parsingCityList() {
        // json 파일(CityList)의 경로 가져오기
        guard let path = Bundle.main.path(forResource: "CityList", ofType: "json") else { return }

        // 경로 내 파일을 String으로 읽어오기
        guard let jsonString = try? String(contentsOfFile: path) else {
            return
        }
        
        // 디코더 선언
        let decoder = JSONDecoder()
        // String -> Data 형식으로 변환
        let data = jsonString.data(using: .utf8)
        // Data 형식으로 변환한 값이 있다면
        if let data {
            do {
                let cityList = try decoder.decode([City].self, from: data)
                self.outputCityListResult.value = (nil, cityList)
                self.originalCityList = cityList
            } catch {
                self.outputCityListResult.value = ("지역 정보들을 가져오는데 실패했어요", nil)
            }
        }
    }
}
