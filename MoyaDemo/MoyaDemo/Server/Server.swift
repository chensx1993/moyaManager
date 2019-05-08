//
//  Server.swift
//  MoyaDemo
//
//  Created by 陈思欣 on 2019/5/8.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Alamofire
import Moya

class WebService: NSObject {
    
    var rootUrl: String = "https://api.github.com"
    
    var timeoutIntervalForRequest: Double = 20.0;
    
    static let sharedInstance = WebService();
    private override init() {}
    
    // session manager
    func manager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = self.timeoutIntervalForRequest
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
    func headers() -> [String : String]? {
        return ["deviceID" : "qwertyyu1234545",
                "Authorization": "tyirhjkkokjjjbggstvj"
        ]
    }
    
    func parameters() -> [String : Any]? {
        return ["platform" : "ios",
                "version" : "1.2.3",
        ]
    }
    
    
}
