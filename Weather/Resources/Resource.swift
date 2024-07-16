//
//  Resource.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import UIKit

enum Resource {
    enum ImageCase: String {
        case calendar = "calendar"
        case map = "map"
        case list = "list.bullet"
        case more = "ellipsis.circle"
        case hashtag = "number"
    }
    
    enum FontCase {
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let bold15 = UIFont.systemFont(ofSize: 15, weight: .bold)
        static let bold16 = UIFont.systemFont(ofSize: 16, weight: .bold)
        static let regular18 = UIFont.systemFont(ofSize: 18)
        static let regular22 = UIFont.systemFont(ofSize: 22)
        static let regular24 = UIFont.systemFont(ofSize: 24)
        static let regular28 = UIFont.systemFont(ofSize: 28)
        static let regular64 = UIFont.systemFont(ofSize: 64)
    }
    
    enum MainSectionCase: String, CaseIterable {
        case header = ""
        case hours = " 3시간 간격의 일기예보"
        case days = " 5일 간의 일기예보"
        case location = " 위치"
        case information = "그 외"
        
        var rowCnt: Int {
            switch self {
            case .header: return 0
            default: return 1
            }
        }
    }
    
    enum DateCase {
        case time
        case days
    }
    
    enum InfoCellCase: String, CaseIterable {
        case wind = "풍속"
        case cloud = "구름"
        case pressure = "기압"
        case humidity = "습도"
        
        var imageName: String {
            switch self {
            case .wind:
                return "wind"
            case .cloud:
                return "cloud.fill"
            case .pressure:
                return "thermometer.low"
            case .humidity:
                return "humidity.fill"
            }
        }
    }
    
    enum CornerCase: CGFloat {
        case defaultCorner = 10
    }
    
    enum ErrorMessage: String {
        case weatherError = "날씨 정보를 불러올 수 없습니다🥲"
    }
}
