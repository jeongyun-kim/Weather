//
//  MapTableViewCell.swift
//  Weather
//
//  Created by 김정윤 on 7/15/24.
//

import UIKit
import MapKit
import SnapKit

final class MapTableViewCell: BaseTableViewCell {
    private let mapView = MKMapView()
    
    override func setupHierarchy() {
        contentView.addSubview(mapView)
    }
    
    override func setupConstraints() {
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(12)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        mapView.layer.cornerRadius = Resource.CornerCase.defaultCorner.rawValue
        mapView.isZoomEnabled = false
        mapView.isScrollEnabled = false
    }
    
    func configureCell(_ data: Location) {
        // 반경 정의
        let meters: CLLocationDistance = 500
        // 중심위치 값
        let coord = CLLocationCoordinate2D(latitude: data.lat, longitude: data.lon)
        // center를 중심으로 반경 200미터까지 보여주기
        let region = MKCoordinateRegion(center: coord, latitudinalMeters: meters, longitudinalMeters: meters)
        // 지도 세팅
        mapView.setRegion(region, animated: true)

        // 이전에 박혀있던 핀 빼기
        mapView.removeAnnotations(mapView.annotations)
        // 핀 생성
        let annotation = MKPointAnnotation()
        // 현재 중심위치로 핀 위치 설정
        annotation.coordinate = coord
        // 핀 박기
        mapView.addAnnotation(annotation)
    }
}
