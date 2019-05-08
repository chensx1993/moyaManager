//
//  Network.swift
//  MoyaDemo
//
//  Created by 陈思欣 on 2019/5/8.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = CommonAPI
    let provider: MoyaProvider<CommonAPI>
}

extension Networking {
    
    static func endpointsClosure<T>() -> (T) -> Endpoint where T: MyServerType {
        return { target in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint;
            // Sign all non-authenticating requests
//            switch target {
//            case .authenticate:
//                return defaultEndpoint
//            default:
//                return defaultEndpoint.adding(newHTTPHeaderFields: ["AUTHENTICATION_TOKEN": GlobalAppStorage.authToken])
//            }
        }
    }
    
    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .immediate;// APIKeys.sharedKeys.stubResponses ? .immediate : .never
    }
    
    static var plugins: [PluginType] {
        return [
            NetworkLogger(blacklist: { target -> Bool in
                guard let target = target as? ArtsyAPI else { return false }
                
                switch target {
                case .ping: return true
                default: return false
                }
            })
        ]
    }
    static var authenticatedPlugins: [PluginType] {
        return [NetworkLogger(whitelist: { target -> Bool in
            guard let target = target as? ArtsyAuthenticatedAPI else { return false }
            
            switch target {
            case .myBidPosition: return true
            case .findMyBidderRegistration: return true
            default: return false
            }
        })
        ]
    }
    
    // (Endpoint, NSURLRequest -> Void) -> Void
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
    
}

private func newProvider<T>(_ plugins: [PluginType] ) -> MoyaProvider<T> where T: NetworkingType {
    return MoyaProvider(endpointClosure: Networking.endpointsClosure(),
                          requestClosure: Networking.endpointResolver(),
                          stubClosure: Networking.APIKeysBasedStubBehaviour,
                          plugins: plugins)
}
