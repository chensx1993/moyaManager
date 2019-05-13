//
//  GitHubAPI.swift
//  MoyaDemo
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/10.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation

public enum GitHub {
    case zen
    case userProfile(String)
    case userRepositories(String)
}

extension GitHub: MyServerType {
    public var path: String {
        switch self {
        case .zen:
            return "/zen"
        case .userProfile(let name):
            return "/users/\(name.urlEscaped)"
        case .userRepositories(let name):
            return "/users/\(name.urlEscaped)/repos"
        }
    }
    
    
    public var parameters: [String: Any]? {
        return ["sort": "pushed"]
    }
    
}
