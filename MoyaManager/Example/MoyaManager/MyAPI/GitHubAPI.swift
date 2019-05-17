//
//  GitHubAPI.swift
//  MoyaDemo
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/10.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import MoyaManager

let networking  = Networking<CommonAPI>()

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

extension String {
    var urlEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? "";
    }
    
}