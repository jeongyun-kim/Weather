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
    private let infoImageView = UIImageView()
    private let infoTypeLabel = UILabel()
    private let infoContentLabel = UILabel()
    
    override func setupHierarchy() {
        contentView.addSubview(infoView)
        infoView.addSubview(infoImageView)
        infoView.addSubview(infoTypeLabel)
        infoView.addSubview(infoContentLabel)
    }
    
    override func setupConstraints() {
        infoView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaInsets).inset(4)
        }
        
        infoImageView.snp.makeConstraints { make in
            make.top.leading.equalTo(infoView).offset(16)
           
        }
        
        infoTypeLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoImageView.snp.trailing).offset(4)
            make.centerY.equalTo(infoImageView.snp.centerY)
        }
        
        infoContentLabel.snp.makeConstraints { make in
            make.leading.equalTo(infoImageView.snp.leading)
            make.top.equalTo(infoTypeLabel.snp.bottom).offset(6)
        }
    }
    
    override func configureLayout() {
        infoView.backgroundColor = .white
        infoView.layer.cornerRadius = 10
        infoTypeLabel.font = Resource.FontCase.regular15
        infoContentLabel.font = Resource.FontCase.regular28
        infoImageView.image = UIImage(systemName: "star")
    }
 
    func configureCell(_ data: [String: String]) {
        guard let infoType = data["infoType"], let infoImage = data["infoImage"],let info = data["info"] else { return }
        // 정보명
        infoTypeLabel.text = infoType
        // 각 정보에 맞는 이미지
        infoImageView.image = UIImage(systemName: infoImage)
        // 각 정보
        infoContentLabel.text = info
    }
}
