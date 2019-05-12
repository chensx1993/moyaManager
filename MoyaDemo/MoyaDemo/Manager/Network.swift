//
//  Network.swift
//  MoyaDemo
//
//  Created by 陈思欣 on 2019/5/8.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

public typealias Success = (_ response: Moya.Response) -> Void
public typealias Failure = (_ error: MoyaError) -> Void

protocol NetworkingType {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}

struct Networking: NetworkingType {
    typealias T = CommonAPI
    let provider: MoyaProvider<CommonAPI> = newProvider(plugins)
}

let networking = Networking.init()

extension Networking {
    
    @discardableResult
    func requestJson<T: MyServerType>(_ target: T,
                                  callbackQueue: DispatchQueue? = DispatchQueue.main,
                                  progress: ProgressBlock? = .none,
                                  success: @escaping (_ response: Any) -> Void,
                                  failure: @escaping Failure) -> Cancellable {
        let provider: MoyaProvider<T> = newProvider(Networking.plugins)
        return provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                do {
                    let json = try response.mapJSON()
                    success(json)
                }catch (let error) {
                    failure(error as! MoyaError)
                }
            case let .failure(error):
                failure(error);
                break
            }
        }
    }
    
    
    @discardableResult
    func request<T: MyServerType>(_ target: T,
                 callbackQueue: DispatchQueue? = DispatchQueue.main,
                 progress: ProgressBlock? = .none,
                 success: @escaping Success,
                 failure: @escaping Failure) -> Cancellable {
        let provider: MoyaProvider<T> = newProvider(Networking.plugins)
        return provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                success(response);
            case let .failure(error):
                failure(error);
                break
            }
        }
    }
    
    @discardableResult
    func requestNormal(_ target: CommonAPI,
                 callbackQueue: DispatchQueue? = DispatchQueue.main,
                 progress: ProgressBlock? = .none,
                 success: @escaping Success,
                 failure: @escaping Failure) -> Cancellable {
        return self.provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case .success(let response):
                success(response);
            case .failure(let error):
                failure(error);
                break
            }
        }
    }
    
}

extension Networking {
    
    static func newDefaultNetworking() -> Networking {
        return Networking()
    }
    
    static func endpointsClosure<T>() -> (T) -> Endpoint where T: MyServerType {
        return { target in
            let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
            return defaultEndpoint;
        }
    }
    
    
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
    
    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never;// APIKeys.sharedKeys.stubResponses ? .immediate : .never
    }
    
    static var plugins: [PluginType] {
        let activityPlugin = NewNetworkActivityPlugin { (state, targetType) in
            switch state {
            case .began:
                DispatchQueue.main.async {
                    if targetType.isShowLoading {
                    }
                }
            case .ended:
                DispatchQueue.main.async {
                    if targetType.isShowLoading {
                        
                    }
                }
            }
        }
        
        return [
            activityPlugin, myLoggorPlugin
        ]
    }
    
    
}

private func newProvider<T>(_ plugins: [PluginType] ) -> MoyaProvider<T> where T: MyServerType {
    return MoyaProvider(endpointClosure: Networking.endpointsClosure(),
                          requestClosure: Networking.endpointResolver(),
                          stubClosure: Networking.APIKeysBasedStubBehaviour,
                          manager:WebService.sharedInstance.manager,
                          plugins: plugins)
}
