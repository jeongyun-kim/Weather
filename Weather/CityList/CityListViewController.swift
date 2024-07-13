//
//  CityListViewController.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit
import SnapKit

final class CityListViewController: BaseViewController {
    private let vm = CityListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        vm.viewDidLoadTrigger.value = ()
    }
    
    override func setupHierarchy() {
        
    }
    
    override func setupConstraints() {
        
    }
    
    override func setupUI() {
        super.setupUI()
        navigationItem.title = "City"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func bind() {
        vm.outputParsingResult.bind { cityList, errorMessage in
            if let errorMessage {
                print(errorMessage)
            } else {
                guard let list = cityList else { return }
                print(list)
            }
        }
    }
}
