//
//  RegularHoursCell.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit
import SnapKit
import Kingfisher

final class RegularHoursCell: BaseCollectionViewCell {
    private let hourLabel: UILabel = {
        let label = UILabel()
        label.font = Resource.FontCase.regular14
        return label
    }()
    private let iconImageView = UIImageView()
    private let tempLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = Resource.FontCase.bold15
        return label
    }()
    
    override func setupHierarchy() {
        contentView.addSubview(hourLabel)
        contentView.addSubview(iconImageView)
        contentView.addSubview(tempLabel)
    }
    
    override func setupConstraints() {
        hourLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.centerX.equalTo(hourLabel.snp.centerX)
            make.size.equalTo(36)
        }
        
        tempLabel.snp.makeConstraints { make in
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
            make.centerX.equalTo(hourLabel.snp.centerX)
        }
    }
    
    func configureCell(_ data: ListData) {
        hourLabel.text = data.formattedDate
        tempLabel.text = data.temp.regularHoursTempString
        guard let url = data.weather.first?.iconURL else { return }
        iconImageView.kf.setImage(with: url)
    }
}
