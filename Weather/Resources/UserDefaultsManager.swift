//
//  UserDefaultsManager.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import Foundation

@propertyWrapper
struct getsetUD {
    var key: String
    var defaultId: String
    let standard = UserDefaults.standard
    
    init(key: String, defaultId: String) {
        self.key = key
        self.defaultId = defaultId
    }
    
    var wrappedValue: String {
        get {
            return standard.string(forKey: key) ?? defaultId
        }
        set {
            standard.setValue(newValue, forKey: key)
        }
    }
}

final class UserDefaultsManager {
    private init() {}
    static let shared = UserDefaultsManager()
    
    @getsetUD(key: "weatherId", defaultId: "1835847") var weatherId: String
    
}
