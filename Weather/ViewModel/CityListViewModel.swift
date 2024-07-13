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
    
    // Output
    // CityList.json 파싱해서 내보낼 값 
    var outputParsingResult: Observable<([City]?, String?)> = Observable((nil, nil))
    // 사용자가 도시 선택 시, 뒤로가기 신호받기
    var viewWillDisappearTrigger: Observable<Void?> = Observable(nil)
    
    init() {
        viewDidLoadTrigger.bind { _ in
            self.parsingCityList()
        }
        
        // 도시가 새로 선택되면 UserDefaults에 저장되어있는 도시ID 변경 
        selectedCity.bind { city in
            guard let city else { return }
            self.ud.weatherId = "\(city.id)"
            // 뒤로가기 신호보내기
            self.viewWillDisappearTrigger.value = ()
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
                self.outputParsingResult.value = (cityList, nil)
            } catch {
                self.outputParsingResult.value = (nil, "지역 정보들을 가져오는데 실패했어요")
            }
        }
    }
}
