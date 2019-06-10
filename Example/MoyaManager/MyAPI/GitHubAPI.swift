//
//  GitHubAPI.swift
//  MoyaDemo
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/10.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import MoyaManager

let gitHubNetworking = Networking<GitHub>()

enum GitHub {
    case mockResponse
    case userProfile(String)
    case userRepositories(String)
}


extension GitHub: MyServerType {
    
    // 如果 baseUrl 跟 MyServerType 一样 ，则不需要重写
    public var base: String { return "https://api.github.com" }
    
    // 如果要重写 base，baseURL 也要重写
    public var baseURL: URL { return URL(string: base)! }
    
    public var path: String {
        switch self {
        case .mockResponse:
            return "/zen"
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .userRepositories(let name):
            return "/users/\(name.urlEscaped)/repos"
        }
    }
    
    // AOP定制公用的paramters
    public var parameters: [String: Any]? {
        return ["sort": "pushed"]
    }
    
    public var headers: [String : String]? {
        return ["testUserToken": "enginowngklsngk"]
    }
    
    // custom method
    public var method: HTTPMethod {
        switch self {
        case .mockResponse:
            return .get
        default:
            return .get
        }
    }
    
    // 是否添加loading
    public var isShowLoading: Bool {
        return false
    }
    
    // mock response，返回假数据
    public var sampleData: Data {
        return "response: test data".data(using: String.Encoding.utf8)!
    }
    
    public var stubBehavior: MyStubBehavior {
        switch self {
        case .mockResponse:
            return .delayed(seconds: 5)
        default:
            return .never
        }
        
    }
    
}

extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "";
    }
    
}
