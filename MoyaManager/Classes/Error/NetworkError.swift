//
//  MyResponse.swift
//  MoyaManager
//
//  Created by chensx on 2019/5/9.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya
import Alamofire

public enum NetworkError: Swift.Error {
    
    /// Indicates a response failed to map to an image.
    case imageMapping(Response)
    
    /// Indicates a response failed to map to a JSON structure.
    case jsonMapping(Response)
    
    /// Indicates a response failed to map to a String.
    case stringMapping(Response)
    
    /// Indicates a response failed to map to a Decodable object.
    case objectMapping(Swift.Error, Response)
    
    /// Indicates that Encodable couldn't be encoded into Data
    case encodableMapping(Swift.Error)
    
    /// Indicates a response failed with an invalid HTTP status code.
    case statusCode(Response)
    
    /// fails to create a valid `URL`.
    case invalidURL
    
    /// when a parameter encoding object throws an error during the encoding process.
    case parameterEncodingFailed(Swift.Error)
    
    /// Indicates a response failed due to an underlying `Error`.
    case underlying(Swift.Error, Response?)
}

public extension NetworkError {
    init(error: Moya.MoyaError) {
        switch error {
        case .imageMapping(let response): self = .imageMapping(response)
        case .jsonMapping(let response): self = .jsonMapping(response)
        case .stringMapping(let response): self = .stringMapping(response)
        case .objectMapping(let error, let response): self = .objectMapping(error, response)
        case .encodableMapping(let error): self = .encodableMapping(error)
        case .statusCode(let response): self = .statusCode(response)
        case .requestMapping: self = .invalidURL
        case .parameterEncoding(let error): self = .parameterEncodingFailed(error)
        case .underlying(let error, let response):
            if let afError = error as? AFError {
                self = NetworkError.init(afError: afError, response: response)
            }else if let moyaError = error as? Moya.MoyaError {
                self = NetworkError.init(error: moyaError)
            }else {
                self = .underlying(error, response)
            }
        }
    }
    
    init(afError: AFError, response: Response?) {
        guard let newResponse = response else {
            self = .underlying(afError, response)
            return
        }
        switch afError {
        case .invalidURL(_): self = .invalidURL
        case .parameterEncodingFailed(_): self = .parameterEncodingFailed(afError)
        case .multipartEncodingFailed(_): self = .underlying(afError, nil)
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(_): self = .statusCode(newResponse)
            default: self = .underlying(afError, response)
            }
        case .responseSerializationFailed(let reason):
            switch reason {
            case .stringSerializationFailed(_): self = .stringMapping(newResponse)
            case .jsonSerializationFailed(_): self = .jsonMapping(newResponse)
            case .propertyListSerializationFailed(let error): self = .objectMapping(error, newResponse)
            default: self = .underlying(afError, newResponse)
            }
        }
    }
}

public extension NetworkError {
    
    var message: String {
        return self.localizedDescription;
    }
    
    var response: Moya.Response? {
        switch self {
        case .imageMapping(let response): return response
        case .jsonMapping(let response): return response
        case .stringMapping(let response): return response
        case .objectMapping(_, let response): return response
        case .encodableMapping(_): return nil
        case .statusCode(let response): return response
        case .invalidURL: return nil
        case .parameterEncodingFailed(_): return nil
        case .underlying(_, let response): return response
        }
    }
    
    internal var underlyingError: Swift.Error? {
        switch self {
        case .imageMapping(_): return nil
        case .jsonMapping(_): return nil
        case .stringMapping(_): return nil
        case .objectMapping(let error, _): return error
        case .encodableMapping(let error): return error
        case .statusCode(_): return nil
        case .invalidURL: return nil
        case .parameterEncodingFailed(let error): return error
        case .underlying(let error, _): return error
        }
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        return "\(self)"
    }
}

extension NetworkError: CustomNSError {
    public var errorUserInfo: [String: Any] {
        var userInfo: [String: Any] = [:]
        userInfo[NSLocalizedDescriptionKey] = errorDescription
        userInfo[NSUnderlyingErrorKey] = underlyingError
        return userInfo
    }
}
