//
//  MyServerTargetType.swift
//  MoyaManager
//
//  Created by 陈思欣 on 2019/5/8.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

public typealias HTTPMethod = Moya.Method
public typealias MyValidationType = Moya.ValidationType
public typealias MySampleResponse = Moya.EndpointSampleResponse
public typealias MyStubBehavior = Moya.StubBehavior

public protocol MyServerType: TargetType {
    var isShowLoading: Bool { get }
    var parameters: [String: Any]? { get }
    var stubBehavior: MyStubBehavior { get }
    var sampleResponse: MySampleResponse { get }
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
    
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var validationType: MyValidationType {
        return .successCodes
    }
    
    public var stubBehavior: StubBehavior {
        return .never
    }
    
    public var sampleData: Data {
        return "response: test data".data(using: String.Encoding.utf8)!
    }
    
    public var sampleResponse: MySampleResponse {
        return .networkResponse(200, self.sampleData)
    }
}

func myBaseUrl(_ path: String) -> String {
    if path.isCompleteUrl { return path }
    return WebService.shared.rootUrl;
}

func myPath(_ path: String) -> String {
    if path.isCompleteUrl { return "" }
    return path;
}

extension String {
    var isCompleteUrl: Bool {
        let scheme = self.lowercased()
        if scheme.contains("http") { return true }
        return false
    }
}


