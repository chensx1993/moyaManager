//
//  NewActivityPlugin.swift
//  MoyaDemo
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/9.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya


/// Notify a request's network activity changes (request begins or ends).
public final class NewNetworkActivityPlugin: PluginType {
    
    public typealias NetworkActivityClosure = (_ change: NetworkActivityChangeType, _ target: MyServerType) -> Void
    let networkActivityClosure: NetworkActivityClosure
    
    /// Initializes a NetworkActivityPlugin.
    public init(networkActivityClosure: @escaping NetworkActivityClosure) {
        self.networkActivityClosure = networkActivityClosure
    }
    
    // MARK: Plugin
    
    /// Called by the provider as soon as the request is about to start
    public func willSend(_ request: RequestType, target: MyServerType) {
        networkActivityClosure(.began, target)
    }
    
    /// Called by the provider as soon as a response arrives, even if the request is canceled.
    public func didReceive(_ result: Result<Moya.Response, MoyaError>, target: MyServerType) {
        networkActivityClosure(.ended, target)
    }
}

