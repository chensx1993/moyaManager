//
//  BBSBOTests.swift
//  BBSBOTests
//
//  Created by zgpeace on 2019/5/7.
//  Copyright © 2019 HSBC. All rights reserved.
//

import XCTest
@testable import BBSBO

class NetworkBaseTestCase: XCTestCase {
    let timeOut: TimeInterval = 30
    var gitHubNetwork: Networking<GitHub>!
    
    override func setUp() {
        super.setUp()
        gitHubNetwork = Networking<GitHub>()
    }

    override func tearDown() {
        super.tearDown()
        gitHubNetwork = nil
    }

}
