//
//  NetworkMonitoringManager.swift
//  Weather
//
//  Created by 김정윤 on 7/14/24.
//

import Foundation
import Network
import Toast
import UIKit

final class NetworkMonitoringManager {
    private init() {}
    static let shared = NetworkMonitoringManager()
    private let monitor = NWPathMonitor() // 네트워크 모니터링 인스턴스
    var isConnected = false
    
    // 네트워크 모니터링 시작
    func startMonitoring() {
        monitor.start(queue: .global())
        // 인터넷 연결 상태 확인 및 네트워크 관련 정보 출력
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied // .satisfied : 네트워크 연결된 상태

            if self.isConnected {
                print("네트워크 연결O")
            } else {
                print("네트워크 연결X")
            }
        }
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
    
}
