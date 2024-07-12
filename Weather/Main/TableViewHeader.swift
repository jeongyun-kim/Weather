//
//  TableViewHeader.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit
import SnapKit

final class TableViewHeader: UITableViewHeaderFooterView {
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.FontCase.regular28
        label.text = "Jeju City"
        return label
    }()
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.FontCase.regular72
        label.text = "5.9°"
        return label
    }()
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.FontCase.regular24
        label.text = "Broken Clouds"
        return label
    }()
    private let convertedTempLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.FontCase.regular22
        label.text = "최고: 7.0° | 최저:-4.2°"
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
    }
    
    private func setupHierarchy() {
        contentView.addSubview(cityLabel)
        contentView.addSubview(tempLabel)
        contentView.addSubview(descLabel)
        contentView.addSubview(convertedTempLabel)
    }
    
    private func setupConstraints() {
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide)
            make.leading.equalTo(tempLabel.snp.leading).offset(4)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.centerX.equalTo(contentView.snp.centerX)
            make.top.equalTo(cityLabel.snp.bottom)
        }
        
        descLabel.snp.makeConstraints { make in
            make.centerX.equalTo(tempLabel.snp.centerX)
            make.top.equalTo(tempLabel.snp.bottom)
        }
        
        convertedTempLabel.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom)
            make.centerX.equalTo(descLabel.snp.centerX)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
