//
//  NetworkStatusTest.swift
//  MoyaManager_Tests
//
//  Created by chensx on 2019/5/29.
//  Copyright © 2019 chensx. All rights reserved.
//

import XCTest
@testable import MoyaManager

class NetworkStatusTestCase: XCTestCase {
    let timeOut: TimeInterval = 10
    var networkStatusManager: NetworkStatusManager!
    var expectation: XCTestExpectation!
    
    
    override func setUp() {
        super.setUp()
        networkStatusManager = NetworkStatusManager.shared
        networkStatusManager.startNetworkReachabilityObserver()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testNetworkStatusObserver() {
        self.expectation = self.expectation(description: "network status check until test")
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusChange(sender:)), name: .networkStatusChange, object: nil)
        
        waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func networkStatusChange(sender: Notification) {
        self.expectation.fulfill()
        
        if let status = sender.object as? NetworkStatus {
            switch status {
            case .notReachable:
                print("notReachable")
                XCTAssert(status == .notReachable)
            case .reachableViaWWAN:
                print("reachableViaWWAN")
                XCTAssert(status == .reachableViaWWAN)
            case .reachableViaWiFi:
                print("reachableViaWiFi")
                XCTAssert(status == .reachableViaWiFi)
            case .unknown:
                print("unknown")
                XCTAssert(status == .unknown)
            }
            return
        }
        
        XCTFail("network status check until test fail")
    }
}
