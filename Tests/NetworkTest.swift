//
//  NetworkTest.swift
//  BBSBOTests
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/23.
//  Copyright © 2019 HSBC. All rights reserved.
//

import Foundation

import XCTest
import Foundation
@testable import BBSBO

class NetworkTest: NetworkBaseTestCase {
    
    func testRequestJson() {
        let expectation = self.expectation(description: "request json")

        var json: Any?
        
        gitHubNetwork.requestJson(.userProfile("chensx1993"), success: { (response) in
            json = response
            expectation.fulfill()
        }) { (error) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        XCTAssertNotNil(json)
    }
    
    func testStubBehavior() {
        let expectation = self.expectation(description: "request stub behavior")
        
        var data: Data?
        
        gitHubNetwork.request(.zen, success: { (response) in
            data = response.data
            expectation.fulfill()
        }) { (error) in
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        if let tempData = data {
            XCTAssertEqual(tempData, GitHub.zen.sampleData)
        }
    }
}
