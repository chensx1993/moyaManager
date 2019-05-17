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


public struct Networking<T: MyServerType> {
    public let provider: MoyaProvider<T> = newProvider(plugins)
    
    public init() {
    }
}

extension Networking {
    
    @discardableResult
    public func requestJson(_ target: T,
                            callbackQueue: DispatchQueue? = DispatchQueue.main,
                            progress: ProgressBlock? = .none,
                            success: @escaping (_ response: Any) -> Void,
                            failure: @escaping Failure) -> Cancellable {
        return self.provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
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
    public func request(_ target: T,
                 callbackQueue: DispatchQueue? = DispatchQueue.main,
                 progress: ProgressBlock? = .none,
                 success: @escaping Success,
                 failure: @escaping Failure) -> Cancellable {
        return self.provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                success(response);
            case let .failure(error):
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
        return .never;
    }
    
    static var plugins: [PluginType] {
        let activityPlugin = NewNetworkActivityPlugin { (state, targetType) in
            switch state {
            case .began:
                if targetType.isShowLoading { //这是我扩展的协议
                    // 显示loading
                }
            case .ended:
                if targetType.isShowLoading { //这是我扩展的协议
                    // 关闭loading
                }
            }
        }
        
        return [
            activityPlugin, myLoggorPlugin
        ]
    }
    
    
}

public func newProvider<T>(_ plugins: [PluginType] ) -> MoyaProvider<T> where T: MyServerType {
    return MoyaProvider(endpointClosure: Networking<T>.endpointsClosure(),
                        requestClosure: Networking<T>.endpointResolver(),
                        stubClosure: Networking<T>.APIKeysBasedStubBehaviour,
                        manager:WebService.sharedInstance.manager,
                        plugins: plugins)
}

//protocol NetworkingType {
//    associatedtype T: TargetType
//    var provider: MoyaProvider<T> { get }
//}
//
//public struct Networking: NetworkingType {
//    public typealias T = CommonAPI
//    public let provider: MoyaProvider<CommonAPI>  = newProvider(plugins)
//
//    public init() {
//    }
//}
