//
//  CommonNetwork.swift
//  MoyaManager
//
//  Created by chensx on 2019/5/14.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

extension Network {
    @discardableResult
    public static func getJson(_ url: String,
                        parameters: [String : Any]? = nil,
                        headers: [String : String]? = nil,
                        callbackQueue: DispatchQueue? = DispatchQueue.main,
                        progress: ProgressBlock? = .none,
                        success: @escaping JsonSuccess,
                        failure: @escaping Failure) -> Cancellable {
        
        let network = Networking<CommonAPI>()
        return network.requestJson(.get(url, parameters: parameters, header: headers), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    @discardableResult
    public static func postJson(_ url: String,
                         parameters: [String : Any]? = nil,
                         headers: [String : String]? = nil,
                         callbackQueue: DispatchQueue? = DispatchQueue.main,
                         progress: ProgressBlock? = .none,
                         success: @escaping JsonSuccess,
                         failure: @escaping Failure) -> Cancellable {
        
        let network = Networking<CommonAPI>()
        return network.requestJson(.post(url, parameters: parameters, header: headers), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    @discardableResult
    public static func get(_ url: String,
                    parameters: [String : Any]? = nil,
                    headers: [String : String]? = nil,
                    callbackQueue: DispatchQueue? = DispatchQueue.main,
                    progress: ProgressBlock? = .none,
                    success: @escaping Success,
                    failure: @escaping Failure) -> Cancellable {
        
        let network = Networking<CommonAPI>()
        return network.request(.get(url, parameters: parameters, header: headers), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
    
    @discardableResult
    public static func post(_ url: String,
                     parameters: [String : Any]? = nil,
                     headers: [String : String]? = nil,
                     callbackQueue: DispatchQueue? = DispatchQueue.main,
                     progress: ProgressBlock? = .none,
                     success: @escaping Success,
                     failure: @escaping Failure) -> Cancellable {
        
        let network = Networking<CommonAPI>()
        return network.request(.post(url, parameters: parameters, header: headers), callbackQueue: callbackQueue, progress: progress, success: success, failure: failure)
    }
}

public struct Network {
    
}

fileprivate enum CommonAPI {
    case get(String, parameters: [String: Any]?, header: [String : String]?)
    case post(String, parameters: [String: Any]?, header: [String : String]?)
}

extension CommonAPI: MyServerType {
    var path: String {
        switch self {
        case .get(let url, _ , _):
            return myPath(url)
        case .post(let url, _ , _):
            return myPath(url)
        }
    }
    
    var base: String {
        switch self {
        case .get(let url, _ , _):
            return myBaseUrl(url)
        case .post(let url, _ , _):
            return myBaseUrl(url)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .get(_ , _ , _):
            return .get
        case .post(_ , _ , _):
            return .post
        }
    }
    
    var parameters: [String: Any]? {
        var requeseParameters = WebService.shared.parameters
        
        var newParameters: [String: Any]?
        
        switch self {
        case .get(_, let parameters, _):
            newParameters = parameters
        case .post(_, let parameters, _):
            newParameters = parameters
        }
        
        if let temp = newParameters {
            temp.forEach { (arg) in
                let (key, value) = arg
                requeseParameters?[key] = value
            }
        }
        return requeseParameters;
    }
}
