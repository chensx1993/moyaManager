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
    var manager: Alamofire.SessionManager = createManager()
    var headers: [String: String]? = defaultHeaders()
    var parameters: [String: Any]? = defaultParameters()
    var timeoutIntervalForRequest: Double = 20.0
    
    static let sharedInstance = WebService()
    private override init() {}
    
    static func defaultHeaders() -> [String : String]? {
        return ["deviceID" : "qwertyyu1234545",
                "Authorization": "tyirhjkkokjjjbggstvj"
        ]
    }
    
    static func defaultParameters() -> [String : Any]? {
        return ["platform" : "ios",
                "version" : "1.2.3",
        ]
    }
    
    // session manager
    static func createManager() -> Alamofire.SessionManager {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Alamofire.SessionManager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = 20.0
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }
    
}

func myBaseUrl(_ path: String) -> String {
    if path.isCompleteUrl { return path }
    return WebService.sharedInstance.rootUrl;
}

func myPath(_ path: String) -> String {
    if path.isCompleteUrl { return "" }
    return path;
}

extension String {
    var isCompleteUrl: Bool {
        if self.contains("http") { return true }
        return false
    }
}
