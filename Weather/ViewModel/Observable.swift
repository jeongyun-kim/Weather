//
//  Observable.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import Foundation

final class Observable<T> {
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {
            closure?(value)
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(closure: @escaping (T) -> Void, initRun: Bool = false) {
        if initRun {
            closure(value)
        }
        self.closure = closure
    }
}
