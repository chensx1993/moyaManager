//
//  MyServerTargetType.swift
//  MoyaDemo
//
//  Created by 陈思欣 on 2019/5/8.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

public protocol MyServerType: TargetType {
    var isShowLoading: Bool { get }
    var parameters: [String: Any]? { get }
}

extension MyServerType {
    var base: String { return WebService.sharedInstance.rootUrl }
    
    var baseURL: URL { return URL(string: base)! }
    
    var headers: [String : String]? { return WebService.sharedInstance.headers() }
    
    var parameters: [String: Any]? { return WebService.sharedInstance.parameters() }
    
    public var method: Moya.Method {
        return .post
    }
    
    var task: Task {
        let encoding: ParameterEncoding
        switch self.method {
        case .post:
            encoding = JSONEncoding.default
        default:
            encoding = URLEncoding.default
        }
        if let requestParameters = parameters {
            return .requestParameters(parameters: requestParameters, encoding: encoding)
        }
        return .requestPlain
    }
    
    var isShowLoading: Bool { return false }
    
    public var sampleData: Data {
        return "test".data(using: String.Encoding.utf8)!
    }
}


