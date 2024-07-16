//
//  CityListViewController.swift
//  Weather
//
//  Created by 김정윤 on 7/12/24.
//

import UIKit
import SnapKit
import Toast

final class CityListViewController: BaseViewController {
    private let vm = CityListViewModel()
    var sendCityData: ((City?) -> Void)?
    private let tableView = UITableView()
    private let searchController = UISearchController()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        print("CityVC init!")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CityVC deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        vm.viewDidLoadTrigger.value = ()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sendCityData?(vm.selectedCity.value)
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
        tableView.backgroundColor = .systemGray6
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CityListTableViewCell.self, forCellReuseIdentifier: CityListTableViewCell.identifier)
        tableView.rowHeight = 80
    }
    
    private func configureSearchController() {
        searchController.searchBar.placeholder = "도시명을 검색해보세요 ex) Seoul"
        searchController.hidesNavigationBarDuringPresentation = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        self.navigationItem.searchController = searchController
        self.searchController.searchResultsUpdater = self
        searchController.searchBar.keyboardType = .alphabet // 영어키보드 기본으로
    }
    
    private func bind() {
        // 뷰 진입 시 CityList.json 파싱 -> 결과에 따라 처리
        vm.outputCityListResult.bind { [weak self] errorMessage, cityList in
            if let errorMessage {
                self?.view.makeToast(errorMessage)
            } else {
                self?.tableView.reloadData()
            }
        }
        
        // 도시 선택하면 뒤로가기
        vm.viewWillDisappearTrigger.bind { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
    }
}

extension CityListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cityList = vm.outputCityListResult.value.1 else { return 0 }
        return cityList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityListTableViewCell.identifier, for: indexPath) as? CityListTableViewCell else { return UITableViewCell() }
        guard let cityList = vm.outputCityListResult.value.1 else { return UITableViewCell() }
        let data = cityList[indexPath.row]
        cell.configureCell(data)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cityList = vm.outputCityListResult.value.1 else { return }
        vm.selectedCity.value = cityList[indexPath.row]
    }
}

extension CityListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let keyword = searchController.searchBar.text else { return }
        vm.searchedKeyword.value = keyword
    }
}
