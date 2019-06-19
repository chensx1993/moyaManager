//
//  NetworkTest.swift
//  MoyaManager_Tests
//
//  Created by chensx on 2019/5/23.
//  Copyright © 2019 chensx. All rights reserved.
//

import XCTest
import Foundation
@testable import MoyaManager

class NetworkTest: XCTestCase {
    
    let timeOut: TimeInterval = 30
    var gitHubNetwork: Networking<UserModuleAPI>!
    
    override func setUp() {
        super.setUp()
        gitHubNetwork = Networking<UserModuleAPI>()
    }
    
    override func tearDown() {
        super.tearDown()
        gitHubNetwork = nil
    }
    
    func testRequestGetJson() {
        let expectation = self.expectation(description: "request json")
        
        var json: Any?
        
        Network.getJson("https://api.github.com/users/chensx1993", success: { (response) in
            json = response
            expectation.fulfill()
        }) { (error) in
            json = []
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        XCTAssertNotNil(json)
    }
    
    // 用法一：简单调用URL，不需要额外创建 enum
    func testGetRequest() {
        
        let expectation = self.expectation(description: "request CommonAPI")
        
        var responseData: Data?
        
        Network.get("https://api.github.com/users/chensx1993", success: { (response) in
            responseData = response.data
            expectation.fulfill()
        }) { (error) in
            responseData = Data()
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        XCTAssertNotNil(responseData)
    }
    
    // 用法二：
    // 1. 创建一个 enum： URL封装在里面
    // 2. AOP拦截所有请求，定制参数(url, param，header，task，isLoading, method etc)
    func testRequestJson() {
        let expectation = self.expectation(description: "request json")

        var json: Any?
        
        // .userProfile("chensx1993": 请求URL集合中的一个
        gitHubNetwork.requestJson(.login("chensx1993"), success: { (response) in
            json = response
            expectation.fulfill()
        }) { (error) in
            json = []
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        XCTAssertNotNil(json)
    }
    
    // 拦截请求，mock response，返回假数据
    func testStubBehavior() {
        let expectation = self.expectation(description: "request stub behavior")
        
        var data: Data?
        
        gitHubNetwork.request(.mockResponse, success: { (response) in
            data = response.data
            expectation.fulfill()
        }) { (error) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        if let tempData = data {
            XCTAssertEqual(tempData, UserModuleAPI.mockResponse.sampleData)
        }
    }
}
