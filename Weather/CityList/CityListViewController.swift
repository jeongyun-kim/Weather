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
    
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        vm.viewDidLoadTrigger.value = ()
    }
    
    override func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        view.backgroundColor = .systemGray6
        navigationItem.title = "City"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityListTableViewCell.self, forCellReuseIdentifier: CityListTableViewCell.identifier)
        tableView.rowHeight = 80
    }
    
    private func bind() {
        vm.outputParsingResult.bind { cityList, errorMessage in
            if let errorMessage {
                print(errorMessage)
            } else {
                self.tableView.reloadData()
            }
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cityList = vm.outputParsingResult.value.0 else { return 0 }
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.identifier, for: indexPath) as? CityListTableViewCell else { return UITableViewCell() }
        guard let cityList = vm.outputParsingResult.value.0 else { return UITableViewCell() }
        let data = cityList[indexPath.row]
        cell.configureCell(data)
        return cell
    }
}
