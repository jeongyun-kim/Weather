//
//  CustomBorder.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit
import SnapKit

final class CustomBorder: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureLayout()
    }
    
    private func configureLayout() {
        backgroundColor = .lightGray.withAlphaComponent(0.5)
        snp.makeConstraints { make in
            make.height.equalTo(1)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
