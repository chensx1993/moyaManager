//
//  ServerTest.swift
//  BBSBOTests
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/23.
//  Copyright © 2019 HSBC. All rights reserved.
//

import XCTest
import Foundation
@testable import BBSBO

class MyServerTest: NetworkBaseTestCase {
    
    func testWebServiceRootUrl() {
        
        WebService.shared.rootUrl = "https://www.baidu.com"
        
        let expectation = self.expectation(description: "request url host should equal to webService url host")
        
        var url: URL?
        let rootUrl: URL = URL(string: WebService.shared.rootUrl)!
        
        gitHubNetwork.request(.userProfile("chensx1993"), success: { (closureResponse) in
            url = closureResponse.request?.url
            expectation.fulfill()
        }) { (error) in
            url = error.response?.request?.url
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        if let requestUrl = url, let host = requestUrl.host, let rootHost = rootUrl.host {
            XCTAssertEqual(host, rootHost)
        } else {
            XCTFail("request url host should equal to webService url host")
        }
    
    }
    
    func testWebServiceDefaultHeaders() {
        
        let expectation = self.expectation(description: "request headers should equal to webService headers")
        
        var requestHeaders: [String : String]?
        let webHeaders = WebService.shared.headers
        
        gitHubNetwork.request(.userProfile("chensx1993"), success: { (response) in
            requestHeaders = response.request?.allHTTPHeaderFields
            expectation.fulfill()
        }) { (error) in
            requestHeaders = error.response?.request?.allHTTPHeaderFields
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        if let headers = requestHeaders, let headers2 = webHeaders {
            XCTAssertEqual(headers, headers2)
        } else {
            XCTFail("request headers should equal to webService headers")
        }
    }
    
    func testWebServiceTimeout() {
        
        WebService.shared.timeoutInterval = 10.0
        
        let expectation = self.expectation(description: "request timeout")
        
        var requestTimeOut: TimeInterval = 0.0
        
        gitHubNetwork.request(.zen, success: { (response) in
            requestTimeOut = response.request?.timeoutInterval ?? 0.0
            expectation.fulfill()
        }) { (error) in
            requestTimeOut = error.response?.request?.timeoutInterval ?? 0.0
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: timeOut, handler: nil)
        
        XCTAssertEqual(requestTimeOut, 10.0)
    }
    
}
