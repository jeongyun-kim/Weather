//
//  CityListTableViewCell.swift
//  Weather
//
//  Created by 김정윤 on 7/13/24.
//

import UIKit
import SnapKit

final class CityListTableViewCell: BaseTableViewCell {
    private let hashtagImageView = UIImageView()
    private let cityNameLabel = UILabel()
    private let countryLabel = UILabel()
    
    override func setupHierarchy() {
        contentView.addSubview(hashtagImageView)
        contentView.addSubview(cityNameLabel)
        contentView.addSubview(countryLabel)
    }
    
    override func setupConstraints() {
        hashtagImageView.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(24)
        }
        
        cityNameLabel.snp.makeConstraints { make in
            make.centerY.equalTo(hashtagImageView.snp.centerY)
            make.leading.equalTo(hashtagImageView.snp.trailing).offset(8)
        }
        
        countryLabel.snp.makeConstraints { make in
            make.leading.equalTo(cityNameLabel.snp.leading)
            make.top.equalTo(cityNameLabel.snp.bottom).offset(8)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        contentView.backgroundColor = .systemGray6
        hashtagImageView.image = UIImage(systemName: Resource.ImageCase.hashtag.rawValue)
    }
    
    func configureCell(_ data: City) {
        cityNameLabel.text = data.name
        countryLabel.text = data.country
    }
}

