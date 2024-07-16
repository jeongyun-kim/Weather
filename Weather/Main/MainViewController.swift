//
//  MainViewController.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import UIKit
import Alamofire
import SnapKit
import Toast

final class MainViewController: BaseViewController {
    private let vm = MainViewModel()
    private let mainTableView = UITableView(frame: .zero, style: .insetGrouped)
    private let border = CustomBorder()
    private let buttonView = UIView()
    private let mapButton = UIButton()
    private let listButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureRefreshControl()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillLoadTrigger.value = ()
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func setupHierarchy() {
        view.addSubview(mainTableView)
        view.addSubview(border)
        view.addSubview(buttonView)
        buttonView.addSubview(mapButton)
        buttonView.addSubview(listButton)
    }
    
    override func setupConstraints() {
        mainTableView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(view)
            make.bottom.equalTo(border.snp.top)
        }
        
        border.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
        }
        
        buttonView.snp.makeConstraints { make in
            make.top.equalTo(border.snp.bottom)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(78)
            make.bottom.equalTo(view)
        }
        
        mapButton.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.top)
            make.leading.equalTo(buttonView.snp.leading).offset(16)
            make.size.equalTo(40)
        }
        
        listButton.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.top)
            make.trailing.equalTo(buttonView.snp.trailing).inset(16)
            make.size.equalTo(40)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        buttonView.backgroundColor = .systemGray6
        mapButton.setImage(UIImage(systemName: Resource.ImageCase.map.rawValue), for: .normal)
        listButton.addTarget(self, action: #selector(listBtnTapped), for: .touchUpInside)
        listButton.setImage(UIImage(systemName: Resource.ImageCase.list.rawValue), for: .normal)
    }
    
    @objc private func listBtnTapped(_ sender: UIButton) {
        let vc = CityListViewController()
        navigationController?.pushViewController(vc, animated: true)
        vc.sendCityData = { city in
            // CityList로부터 받아온 도시 데이터 
            self.vm.inputCityData.value = city
        }
    }
    
    override func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(TableViewHeader.self, forHeaderFooterViewReuseIdentifier: TableViewHeader.identifier)
        mainTableView.register(RegularHoursTableViewCell.self, forCellReuseIdentifier: RegularHoursTableViewCell.identifier)
        mainTableView.register(RegularDaysTableViewCell.self, forCellReuseIdentifier: RegularDaysTableViewCell.identifier)
        mainTableView.register(MapTableViewCell.self, forCellReuseIdentifier: MapTableViewCell.identifier)
        mainTableView.register(InformationTableViewCell.self, forCellReuseIdentifier: InformationTableViewCell.identifier)
        mainTableView.sectionHeaderTopPadding = CGFloat(0)
     }
    
    // 새로고침
    private func configureRefreshControl() {
        mainTableView.refreshControl = UIRefreshControl()
        mainTableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    @objc private func refresh() {
        // 0.5초 뒤에 뷰 다시 불러오게 -> refreshEnd
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.vm.viewWillLoadTrigger.value = ()
            self.mainTableView.refreshControl?.endRefreshing()
        }
    }
    
    private func bind() {
        vm.endedRequestTrigger.bind { [weak self] _ in
            if let errorMessage = self?.vm.weatherErrorMessage.value {
                self?.view.makeToast(errorMessage)
            } else {
                self?.mainTableView.reloadData()
            }
        }
        
        vm.networkErrorMessage.bind(closure: { [weak self] errorMessage in
            if let errorMessage {
                self?.view.makeToast(errorMessage)
            }
        }, initRun: true)
    }
}

// MARK: TableViewExtension
extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    // 테이블뷰 내 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        let mainSectionCnt = Resource.MainSectionCase.allCases.count
        return tableView == mainTableView ? mainSectionCnt : 1
    }
    
    // 테이블뷰 내 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainRowCnt = Resource.MainSectionCase.allCases[section].rowCnt
        let daysRowCnt = vm.weatherForFiveDays.value.count
        return tableView == mainTableView ? mainRowCnt : daysRowCnt
    }
    
    // mainTableView에서 보여질 섹션 제목 / daysTableView는 없음
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let mainSectionTitle = Resource.MainSectionCase.allCases[section].rawValue
        return tableView == mainTableView ? mainSectionTitle : nil
    }
    
    // 테이블뷰 셀 구성 (MainVC에서 사용하는 mainTableView / 5일간의 일기예보를 보여주는 daysTableView가 있음 )
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTableView {
            let sectionCase = Resource.MainSectionCase.allCases[indexPath.section]
            
            switch sectionCase {
            case .header:
                return UITableViewCell()
                
            case .hours: // 3시간 간격
                let cell = tableView.dequeueReusableCell(withIdentifier: RegularHoursTableViewCell.identifier, for: indexPath) as! RegularHoursTableViewCell
                cell.collectionView.register(RegularHoursCell.self, forCellWithReuseIdentifier: RegularHoursCell.identifier)
                cell.collectionView.tag = 1
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                return cell
                
            case .days: // 5일간 날씨
                let cell = tableView.dequeueReusableCell(withIdentifier: RegularDaysTableViewCell.identifier, for: indexPath) as! RegularDaysTableViewCell
                cell.daysTableView.register(RegularDaysCell.self, forCellReuseIdentifier: RegularDaysCell.identifier)
                cell.daysTableView.dataSource = self
                cell.daysTableView.delegate = self
                cell.daysTableView.reloadData()
                return cell
          
            case .location:
                guard let location = vm.outputLocation.value else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(withIdentifier: MapTableViewCell.identifier, for: indexPath) as! MapTableViewCell
                cell.configureCell(location)
                return cell
                
            case .information: // 그 외 정보
                let cell = tableView.dequeueReusableCell(withIdentifier: InformationTableViewCell.identifier, for: indexPath) as! InformationTableViewCell
                cell.collectionView.register(WeatherInformationCell.self, forCellWithReuseIdentifier: WeatherInformationCell.identifier)
                cell.collectionView.tag = 2
                cell.collectionView.dataSource = self
                cell.collectionView.delegate = self
                cell.collectionView.reloadData()
                return cell
            }
        } else { // 5일치 날씨 내 테이블뷰라면
            let cell = tableView.dequeueReusableCell(withIdentifier: RegularDaysCell.identifier, for: indexPath) as! RegularDaysCell
            cell.configureCell(vm.weatherForFiveDays.value[indexPath.row])
            return cell
        }
    }
    
    // 헤더 구성
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionCase = Resource.MainSectionCase.allCases[section]
        if tableView == mainTableView, sectionCase == .header {
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: TableViewHeader.identifier) as! TableViewHeader
            header.configureHeader(vm.headerWeather.value)
            return header
        } else {
            return nil
        }
    }
    
    // 각 셀 섹션 높이
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == mainTableView, section == 0 { // mainTableView 내 HeaderView라면
            return 200
        } else if tableView == mainTableView { // mainTableView 내 다른 Cell이라면
            return 30
        } else { // 5일간의 일기예보라면
            return 0
        }
    }
    
    // 각 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mainTableView {
            let cellCase = Resource.MainSectionCase.allCases[indexPath.section]
            switch cellCase {
            case .header:
                return 0
            case .hours:
                return 130
            case .days:
                return 250
            case .location:
                return 200
            case .information:
                return 300
            }
        } else {
            return 50
        }
    }
}

// MARK: CollectionViewExtension
// 3시간 간격 일기예보
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 1 {
            return vm.regularHoursWeathers.value.count
        } else {
            return vm.weatherInfoArr.value.count
        }
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView.tag == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegularHoursCell.identifier, for: indexPath) as! RegularHoursCell
            cell.configureCell(vm.regularHoursWeathers.value[indexPath.row])
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WeatherInformationCell.identifier, for: indexPath) as! WeatherInformationCell
            cell.configureCell(vm.weatherInfoArr.value[indexPath.row])
            return cell
        }
    }
}
