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
    var stubBehavior: StubBehavior { get }
}

extension MyServerType {
    public var base: String { return WebService.shared.rootUrl }
    
    public var baseURL: URL { return URL(string: base)! }
    
    public var headers: [String : String]? { return WebService.shared.headers }
    
    public var parameters: [String: Any]? { return WebService.shared.parameters }
    
    public var isShowLoading: Bool { return false }
    
    public var task: Task {
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
    
    
    public var method: Moya.Method {
        return .get
    }
    
    public var sampleData: Data {
        return "response: test data".data(using: String.Encoding.utf8)!
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
    
    public var stubBehavior: StubBehavior {
        return .never
    }
}


