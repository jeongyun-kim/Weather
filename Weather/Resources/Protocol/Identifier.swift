//
//  Identifier.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit

protocol Identifier {
    static var identifier: String { get }
}

extension UIView: Identifier {
    static var identifier: String {
       return String(describing: self)
    }
}
