//
//  MainViewController.swift
//  Weather
//
//  Created by 김정윤 on 7/11/24.
//

import UIKit
import SnapKit
import Alamofire

final class MainViewController: BaseViewController {
    private let vm = MainViewModel()
    private let mainTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.viewWillLoadTrigger.value = ()
    }
    
    override func setupHierarchy() {
        view.addSubview(mainTableView)
    }
    
    override func setupConstraints() {
        mainTableView.snp.makeConstraints { make in
            make.edges.equalTo(view)
        }
    }
    
    override func setupUI() {
        super.setupUI()
    }
    
    override func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(TableViewHeader.self, forHeaderFooterViewReuseIdentifier: TableViewHeader.identifier)
        mainTableView.register(RegularHoursTableViewCell.self, forCellReuseIdentifier: RegularHoursTableViewCell.identifier)
        mainTableView.register(RegularDaysTableViewCell.self, forCellReuseIdentifier: RegularDaysTableViewCell.identifier)
        mainTableView.sectionHeaderTopPadding = CGFloat(0)
     }
    
    private func bind() {
        vm.endedRequestTrigger.bind { _ in
            self.mainTableView.reloadData()
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    // 테이블뷰 내 섹션의 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        let mainSectionCnt = Resource.MainTableCellCase.allCases.count
        return tableView == mainTableView ? mainSectionCnt : 1
    }
    
    // 테이블뷰 내 셀의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let mainRowCnt = Resource.MainTableCellCase.allCases[section].rowCnt
        let daysRowCnt = vm.weatherForFiveDays.value.count
        return tableView == mainTableView ? mainRowCnt : daysRowCnt
    }
    
    // mainTableView에서 보여질 섹션 제목 / daysTableView는 없음
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let mainSectionTitle = Resource.MainTableCellCase.allCases[section].rawValue
        return tableView == mainTableView ? mainSectionTitle : nil
    }
    
    // 테이블뷰 셀 구성 (MainVC에서 사용하는 mainTableView / 5일간의 일기예보를 보여주는 daysTableView가 있음 )
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == mainTableView {
            let cellCase = Resource.MainTableCellCase.allCases[indexPath.section]
            switch cellCase {
            case .hours: // 3시간 간격
                let cell = tableView.dequeueReusableCell(withIdentifier: RegularHoursTableViewCell.identifier, for: indexPath) as! RegularHoursTableViewCell
                cell.collectionView.register(RegularHoursCell.self, forCellWithReuseIdentifier: RegularHoursCell.identifier)
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
                
            default:
                return UITableViewCell()
            }
        } else { // 5일치 날씨 내 테이블뷰라면
            let cell = tableView.dequeueReusableCell(withIdentifier: RegularDaysCell.identifier, for: indexPath) as! RegularDaysCell
            cell.configureCell(vm.weatherForFiveDays.value[indexPath.row])
            return cell
        }
    }
    
    // 헤더 구성
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cellCase = Resource.MainTableCellCase.allCases[section]
        if tableView == mainTableView, cellCase == .header {
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
            return 20
        } else { // 5일간의 일기예보라면
            return 0
        }
    }
    
    // 각 셀의 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == mainTableView {
            let cellCase = Resource.MainTableCellCase.allCases[indexPath.section]
            switch cellCase {
            case .hours: return 130
            case .days: return 250
            default: return 100
            }
        } else {
            return 50
        }
    }
}

// MARK: CollectionView+
// 3시간 간격 일기예보
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    // 셀의 개수
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.regularHoursWeathers.value.count
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RegularHoursCell.identifier, for: indexPath) as! RegularHoursCell
        cell.configureCell(vm.regularHoursWeathers.value[indexPath.row])
        return cell
    }
}
