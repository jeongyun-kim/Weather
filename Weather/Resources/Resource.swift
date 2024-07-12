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
    }
    
    enum FontCase {
        static let regular14 = UIFont.systemFont(ofSize: 14)
        static let regular15 = UIFont.systemFont(ofSize: 15)
        static let bold17 = UIFont.systemFont(ofSize: 17, weight: .bold)
        static let regular22 = UIFont.systemFont(ofSize: 22)
        static let regular24 = UIFont.systemFont(ofSize: 24)
        static let regular28 = UIFont.systemFont(ofSize: 28)
        static let regular72 = UIFont.systemFont(ofSize: 72)
    }
    
    enum MainTableCellCase: String, CaseIterable {
        case header = ""
        case hours = " 3시간 간격의 일기예보"
        case days = " 5일 간의 일기예보"
        case location = " 위치"
        case none = " "
        
        var rowCnt: Int {
            switch self {
            case .header: return 0
            default: return 1
            }
        }
        
        var imageName: String? {
            switch self {
            case .none, .header:
                return nil
            case .hours, .days:
                return "calendar"
            case .location:
                return "thermometer.low"
            }
        }
    }
}
