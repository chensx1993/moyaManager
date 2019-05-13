//
//  LoginAPI.swift
//  MoyaDemo
//
//  Created by 陈思欣 on 2019/5/8.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

let userModuleProvider = MoyaProvider<UserModule>(plugins: [myLoggorPlugin])

public enum UserModule {
    case login(username: String, password: String)
    case logout
}

extension UserModule: TargetType {
    
    public var baseURL: URL { return URL(string: WebService.sharedInstance.rootUrl)! }
    
    public var path: String {
        switch self {
        case .login(let username, _ ):
            return "/users/\(username.urlEscaped)"
        default:
            return "/zen"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .logout:
            return .post
        default:
            return .get
        }
    }
    
    public var sampleData: Data {
        switch self {
        case .login(let username):
            return "{\"login\": \"\(username)\", \"id\": 100}".data(using: String.Encoding.utf8)!
        default:
            return "Half measures are as bad as nothing at all.".data(using: String.Encoding.utf8)!
        }
    }
    
    public var task: Task {
        switch self {
        case .login:
            return .requestParameters(parameters: ["sort": "pushed"], encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    public var headers: [String : String]? {
        return nil;
    }
    
}

