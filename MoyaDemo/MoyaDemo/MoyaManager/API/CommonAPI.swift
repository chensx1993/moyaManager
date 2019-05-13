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
    case url2(String, parameters: [String: Any]?)
    case url3(String, parameters: [String: Any]?, header: [String : String])
}

extension CommonAPI: MyServerType {
    var path: String {
        switch self {
        case .url(let url):
            return myPath(url)
        case .url2(let url, _):
            return myPath(url)
        case .url3(let url, _ , _):
            return myPath(url)
        }
    }

    var base: String {
        switch self {
        case .url(let url):
            return myBaseUrl(url)
        case .url2(let url, _):
            return myBaseUrl(url)
        case .url3(let url, _ , _):
            return myBaseUrl(url)
        }
    }
    
     var parameters: [String: Any]? {
        var requeseParameters = WebService.sharedInstance.parameters
        
        var newParameters: [String: Any]?
        
        switch self {
        case .url2(_, let parameters):
            newParameters = parameters
        case .url3(_, let parameters, _):
            newParameters = parameters
        default:
            return requeseParameters
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
