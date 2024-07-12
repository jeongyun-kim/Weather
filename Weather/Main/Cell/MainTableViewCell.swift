//
//  MainTableViewCell.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit

final class MainTableViewCell: BaseTableViewCell {
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    override func setupHierarchy() {
        contentView.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
        }
    }
    
    override func configureLayout() {
    }
    
    private func layout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 6
        let inset: CGFloat = 24
        
        let size = (UIScreen.main.bounds.width - 4*spacing - 2*inset) / 5
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.itemSize = CGSize(width: size, height: size*2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: 0)
        return layout
    }
}


