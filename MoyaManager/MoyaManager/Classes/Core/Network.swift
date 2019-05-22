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
public typealias Failure = (_ error: NetworkError) -> Void
public typealias JsonSuccess = (_ response: Any) -> Void


public struct Networking<T: MyServerType> {
    public let provider: MoyaProvider<T>
    
    public init(provider: MoyaProvider<T> = newDefaultProvider()) {
        self.provider = provider
    }
}

extension Networking {
    
    @discardableResult
    public func requestJson(_ target: T,
                            callbackQueue: DispatchQueue? = DispatchQueue.main,
                            progress: ProgressBlock? = .none,
                            success: @escaping JsonSuccess,
                            failure: @escaping Failure) -> Cancellable {
        return self.provider.request(target, callbackQueue: callbackQueue, progress: progress) { (result) in
            switch result {
            case let .success(response):
                do {
                    let json = try handleResponse(response)
                    success(json)
                }catch (let error) {
                    failure(error as! NetworkError)
                }
            case let .failure(error):
                failure(NetworkError.moyaError(error))
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
                failure(NetworkError.moyaError(error));
                break
            }
        }
    }
    
}

extension Networking {
    
    public static func newDefaultProvider() -> MoyaProvider<T> {
        return newProvider(plugins)
    }
    
    public static func newDefaultNetworking() -> Networking {
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
                request.timeoutInterval = WebService.shared.timeoutInterval
                closure(.success(request))
            } catch let error {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
    
    static func APIKeysBasedStubBehaviour<T>(_ target: T) -> Moya.StubBehavior where T: MyServerType {
        return target.stubBehavior;
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

func newProvider<T>(_ plugins: [PluginType] ) -> MoyaProvider<T> where T: MyServerType {
    return MoyaProvider(endpointClosure: Networking<T>.endpointsClosure(),
                        requestClosure: Networking<T>.endpointResolver(),
                        stubClosure: Networking<T>.APIKeysBasedStubBehaviour,
                        manager:WebService.shared.manager,
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
