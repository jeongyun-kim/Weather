//
//  DateFormatterManager.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import Foundation

final class DateFormatterManager {
    private init() {}
    static let shared = DateFormatterManager()
    static let dateFormatter = DateFormatter()
    
    func dateToString(_ data: String, type: Resource.DateCase = .time) -> String {
        let dateFormatter = DateFormatterManager.dateFormatter
        dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "ko_KR")
        // 5일간의 일기예보에서 첫 데이터 날짜는 '오늘'로 받아오고 있기 때문에 날짜 변환 불가 -> 그대로 오늘 반환
        guard let newDate = dateFormatter.date(from: data) else { return data }
        dateFormatter.dateFormat = type.format
        let result = dateFormatter.string(from: newDate)
        return result
    }
}
