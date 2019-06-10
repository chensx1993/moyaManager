//
//  ServerTest.swift
//  MoyaManager_Tests
//
//  Created by chensx on 2019/5/23.
//  Copyright © 2019 chensx. All rights reserved.
//

import XCTest
import Foundation
@testable import MoyaManager

class MyServerTest: XCTestCase {
    
    let timeOut: TimeInterval = 30
    var userNetwork: Networking<UserModuleAPI>!
    var defaultUrl: String!
    
    override func setUp() {
        super.setUp()
        userNetwork = Networking<UserModuleAPI>()
    
        defaultUrl = WebService.shared.rootUrl
    }
    
    override func tearDown() {
        super.tearDown()
        userNetwork = nil
        
        WebService.shared.rootUrl = defaultUrl
        WebService.shared.timeoutInterval = 30.0
        WebService.shared.headers = WebService.defaultHeaders()
    }
    
    func testWebServiceRootUrl() {
        
        WebService.shared.rootUrl = "https://www.baidu.com"
        
        let webRootUrl = WebService.shared.rootUrl
        let requestUrl = self.userNetwork.provider.endpoint(.logout).url //complete URL
        if let url = URL(string: requestUrl), let webURL = URL(string: webRootUrl) {
            XCTAssertEqual(url.host!, webURL.host!)
        }else {
            XCTFail("testWebServiceRootUrl fail")
        }
    }
    
    func testWebServiceDefaultHeaders() {
        
        WebService.shared.headers = ["key1": "test1", "key2": "test2"]
        
        let myHeaders = WebService.shared.headers
        let requestHeaders = self.userNetwork.provider.endpoint(.logout).httpHeaderFields
        
        XCTAssertEqual(myHeaders, requestHeaders)
    }
    
    func testWebServiceParameters() {
        
    }
    
    func testWebServiceTimeout() {
        
        WebService.shared.timeoutInterval = 15.0

        let expectation = self.expectation(description: "request timeout")
        
        var requestTimeOut: TimeInterval = 0.0
        
        userNetwork.request(.logout, success: { (response) in
            requestTimeOut = response.request?.timeoutInterval ?? 0.0
            expectation.fulfill()
        }) { (error) in
            requestTimeOut = 15.0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        XCTAssertEqual(requestTimeOut, 15.0)

    }

}
