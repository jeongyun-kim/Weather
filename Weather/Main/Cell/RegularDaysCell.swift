//
//  RegularDaysCell.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit
import SnapKit
import Kingfisher

final class RegularDaysCell: BaseTableViewCell {
    private let iconImageView = UIImageView()
    private let dayLabel = UILabel()
    private let minTempLabel = UILabel()
    private let maxTempLabel = UILabel()
    
    override func setupHierarchy() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(minTempLabel)
        contentView.addSubview(maxTempLabel)
    }
    
    override func setupConstraints() {
        dayLabel.snp.makeConstraints { make in
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(32)
            make.centerY.equalTo(contentView.snp.centerY)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(dayLabel.snp.centerY)
            make.trailing.equalTo(minTempLabel.snp.leading).offset(-16)
            make.size.equalTo(36)
        }
        
        minTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(iconImageView.snp.centerY)
            make.centerX.equalTo(contentView.snp.centerX)
        }
        
        maxTempLabel.snp.makeConstraints { make in
            make.centerY.equalTo(minTempLabel.snp.centerY)
            make.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(32)
        }
    }
    
    override func configureLayout() {
        [dayLabel, minTempLabel, maxTempLabel].forEach { label in
            label.font = Resource.FontCase.regular18
        }
        minTempLabel.textColor = .lightGray
    }
    
    func configureCell(_ data: RegularDaysWeather) {
        let dateString = DateFormatterManager.shared.dateToString(data.date, type: .days)
        dayLabel.text = dateString
        guard let iconURL = data.iconURL else { return }
        iconImageView.kf.setImage(with: iconURL)
        minTempLabel.text = "최저 \(data.tempMin)"
        maxTempLabel.text = "최고 \(data.tempMax)"
    }
}
