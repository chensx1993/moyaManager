//
//  UserAPI.swift
//  MoyaManager_Tests
//
//  Created by chensx on 2019/6/4.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
@testable import MoyaManager

// create API
enum UserModuleAPI: MyServerType {
    case login(String)
    case logout
    case testHTTPCode404
    case testJsonMappingError
    case mockResponse
}

extension UserModuleAPI {
    public var path: String {
        switch self {
        case .logout:
            return "/zen"
        case .login(let name):
            return "/users/\(name.urlEscaped)"
        case .testHTTPCode404:
            return "/testHTTPCode"
        case .testJsonMappingError:
            return "/test"
        case .mockResponse:
            return "/mockResponse"
            
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var stubBehavior: MyStubBehavior {
        switch self {
        case .testHTTPCode404: return .immediate
        case .testJsonMappingError: return .immediate
        case .mockResponse: return .delayed(seconds: 5)
        default: return .never
        }
    }
    
    var sampleResponse: MySampleResponse {
        switch self {
        case .testHTTPCode404:
            return .networkResponse(404, sampleData)
        default:
            return .networkResponse(200, sampleData)
        }
    }
}
