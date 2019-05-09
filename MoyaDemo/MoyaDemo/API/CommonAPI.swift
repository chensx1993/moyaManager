//
//  CommonAPI.swift
//  MoyaDemo
//
//  Created by 陈思欣 on 2019/5/8.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation

enum CommonAPI {
    case url(String)
    case url(String, parameters: String)
    case url(String, parameters: [String : Any], header: [String : String])
}

extension CommonAPI: MyServerType {
    
    var base: String {
        switch self {
        case .url(let url, _ , _):
            if url.contains("http") {
                return "";
            }
            return WebService.sharedInstance.rootUrl
        default:
            return WebService.sharedInstance.rootUrl
        }
    }
    
    var path: String {
        switch self {
        case .url(let url, _ , _):
            return url;
        default:
            return "";
        }
    }
    
     var parameters: [String: Any]? {
        var requeseParameters = WebService.sharedInstance.parameters()
        
        switch self {
        case .url(_, let parameters , _):
            parameters.forEach { (arg) in
                let (key, value) = arg
                requeseParameters?[key] = value
            }
            return requeseParameters;
        default:
            return requeseParameters
        }
    }
        
}
