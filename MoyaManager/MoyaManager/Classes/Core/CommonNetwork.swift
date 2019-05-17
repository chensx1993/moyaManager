//
//  CommonNetwork.swift
//  MoyaDemo
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/14.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

@discardableResult
public func requestJson<T: MyServerType>(_ target: T,
                                  callbackQueue: DispatchQueue? = DispatchQueue.main,
                                  progress: ProgressBlock? = .none,
                                  success: @escaping (_ response: Any) -> Void,
                                  failure: @escaping Failure) -> Cancellable {
    let provider: MoyaProvider<T> = newProvider(Networking<T>.plugins)
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
public func request<T: MyServerType>(_ target: T,
                              callbackQueue: DispatchQueue? = DispatchQueue.main,
                              progress: ProgressBlock? = .none,
                              success: @escaping Success,
                              failure: @escaping Failure) -> Cancellable {
    let provider: MoyaProvider<T> = newProvider(Networking<T>.plugins)
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
