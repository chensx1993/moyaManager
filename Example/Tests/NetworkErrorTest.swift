//
//  NetworkErrorTest.swift
//  MoyaManager_Tests
//
//  Created by chensx on 2019/6/4.
//  Copyright © 2019 chensx. All rights reserved.
//

import XCTest
import Foundation
@testable import MoyaManager

class NetworkErrorTest: XCTestCase {
    let timeOut: TimeInterval = 30
    var userNetwork: Networking<UserModuleAPI>!
    
    override func setUp() {
        super.setUp()
        
        userNetwork = Networking<UserModuleAPI>()
    }
    
    override func tearDown() {
        super.tearDown()
        
        userNetwork = nil
    }
    
    func testJsonMappingError() {
        let expectation = self.expectation(description: "test json mapping error")
        
        var error: NetworkError?
        
        userNetwork.requestJson(.testJsonMappingError, success: { (response) in
            expectation.fulfill()
        }) { (requestError) in
            error = requestError
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: timeOut, handler: nil)
        
        if case .jsonMapping(_)? = error {
            XCTAssert(true, "error should equal to .jsonMappin")
        }else {
            XCTFail("error should equal to .jsonMappin")
        }
    }
    
    func testHTTPStatusCode404() {
        
        let expectation = self.expectation(description: "test HTTP statusCode 404")
        
        var error: NetworkError?
        
        userNetwork.request(.testHTTPCode404, success: { (response) in
            expectation.fulfill()
        }) { (requestError) in
            error = requestError
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: timeOut, handler: nil)
        
        if case let .statusCode(response)? = error {
            XCTAssert(response.statusCode == 404, "HTTP statusCode should equal to 404")
        }else {
            XCTFail("HTTP statusCode should equal to 404")
        }
    }
    
}


