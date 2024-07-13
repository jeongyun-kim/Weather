//
//  InformationTableViewCell.swift
//  Weather
//
//  Created by 김정윤 on 7/13/24.
//

import UIKit
import SnapKit

final class InformationTableViewCell: BaseTableViewCell {
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    override func setupHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
    }
    
    private func layout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
       
        let section = NSCollectionLayoutSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    override func configureLayout() {
        collectionView.backgroundColor = .systemGray6
    }
}
