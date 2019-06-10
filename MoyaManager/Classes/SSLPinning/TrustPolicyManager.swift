//
//  TrustPolicyManager.swift
//  MoyaManager
//
//  Created by chensx on 2019/6/6.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Alamofire

extension ServerTrustPolicyManager {
    
    static let defaultManager: ServerTrustPolicyManager = ServerTrustPolicyManager(policies: ["test.com": defaultServerTrustPolicy()])
    
    
    static func defaultServerTrustPolicy() -> ServerTrustPolicy {
        return .customEvaluation({ (secTrust, host) -> Bool in
            let evaluate = ServerTrustPolicy.performDefaultEvaluation(validateHost: false).evaluate(secTrust, forHost: host)
            return evaluate
        })
    }
}
