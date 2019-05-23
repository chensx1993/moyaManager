//
//  MyResponse.swift
//  MoyaDemo
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/9.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

public enum NetworkError: Error  {
    
    case dictionaryMapping(Response)

    case serverResponse(message: String?, code: Int, response: Response)
    
    case moyaError(Moya.MoyaError)
    
    case unknownError(Response)
}

public extension NetworkError {
    
    var response: Moya.Response? {
        switch self {
        case .dictionaryMapping(let response): return response
        case .serverResponse(_, _, let response): return response
        case .moyaError(let error): return error.response
        case .unknownError(let response): return response
        }
    }
}
