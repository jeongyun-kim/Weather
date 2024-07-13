//
//  CityList.swift
//  Weather
//
//  Created by 김정윤 on 7/13/24.
//

import Foundation

struct City: Decodable {
    let id: Int
    let name: String
    let state: String
    let country: String
    let coord: Location
}
