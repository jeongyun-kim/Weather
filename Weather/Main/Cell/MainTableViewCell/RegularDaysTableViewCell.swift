//
//  RegularDaysTableViewCell.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit
import SnapKit

final class RegularDaysTableViewCell: BaseTableViewCell {
    let daysTableView = UITableView()
    
    override func setupHierarchy() {
        contentView.addSubview(daysTableView)
    }
    
    override func setupConstraints() {
        daysTableView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        daysTableView.sectionHeaderTopPadding = 0
        daysTableView.tag = 1
    }
}
