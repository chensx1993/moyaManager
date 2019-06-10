//
//  NetworkStatusManager.swift
//  MoyaManager
//
//  Created by chensx on 2019/5/24.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Alamofire

public enum NetworkStatus {
    case unknown
    case notReachable
    case reachableViaWiFi
    case reachableViaWWAN
}

class NetworkStatusManager: NSObject {
    
    static let shared = NetworkStatusManager()
    private override init() {}
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.apple.com")
    
    var isReachable: Bool { return isReachableOnWWAN || isReachableOnWiFi }
    
    var isReachableOnWWAN: Bool { return networkStatus == .reachableViaWWAN }

    var isReachableOnWiFi: Bool { return networkStatus == .reachableViaWiFi }
    
    var networkStatus: NetworkStatus {
        guard let status = reachabilityManager?.networkReachabilityStatus else {
            return .unknown
        }
        switch status {
        case .unknown:
            return NetworkStatus.unknown
        case .notReachable:
            return NetworkStatus.notReachable
        case .reachable(.ethernetOrWiFi):
            return NetworkStatus.reachableViaWiFi
        case .reachable(.wwan):
            return NetworkStatus.reachableViaWWAN
        }
    }
    
    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                print("The network is not reachable")
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
            }
            NotificationCenter.default.post(name: .networkStatusChange, object: self.networkStatus)
        }
        reachabilityManager?.startListening()
    }
}

extension Notification.Name {
    static let networkStatusChange = Notification.Name("networkStatusChange")
}
