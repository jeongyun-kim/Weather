//
//  WeatherInformationCell.swift
//  Weather
//
//  Created by 김정윤 on 7/13/24.
//

import UIKit
import SnapKit

final class WeatherInformationCell: BaseCollectionViewCell {
    private let infoView = UIView()
    private let categoryImageView = UIImageView()
    private let categoryLabel = UILabel()
    private let contentLabel = UILabel()
    
    override func setupHierarchy() {
        contentView.addSubview(infoView)
        infoView.addSubview(categoryImageView)
        infoView.addSubview(categoryLabel)
        infoView.addSubview(contentLabel)
    }
    
    override func setupConstraints() {
        infoView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaInsets).inset(4)
        }
        
        categoryImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(infoView).offset(16)
           
        }
        
        categoryLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryImageView.snp.trailing).offset(4)
            make.centerY.equalTo(categoryImageView.snp.centerY)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(categoryImageView.snp.leading)
            make.top.equalTo(categoryLabel.snp.bottom).offset(6)
        }
    }
    
    override func configureLayout() {
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 10
        categoryLabel.font = Resource.FontCase.regular15
        contentLabel.font = Resource.FontCase.regular28
        categoryImageView.image = UIImage(systemName: "star")
    }
 
    func configureCell(_ data: [String]) {
        // 정보명
        categoryLabel.text = data[0]
        // 각 정보에 맞는 이미지
        categoryImageView.image = UIImage(systemName: data[1])
        // 각 정보
        contentLabel.text = data[2]
    }
}
