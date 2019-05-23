//
//  MyResponse.swift
//  MoyaDemo
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/9.
//  Copyright © 2019 chensx. All rights reserved.
//

import Foundation
import Moya

func handleResponse(_ response: Moya.Response) throws -> Any {
    do {
        let json = try response.mapJSON()
    
        guard let dict = json as? [String : Any] else {
            throw NetworkError.dictionaryMapping(response)
        }
        
        if let code = dict["code"] as? String {
            if code == "200" {
                return dict
            }
            
            let message = dict["message"] as? String
            throw NetworkError.serverResponse(message: message, code: Int(code) ?? -1, response: response)
            
        }
        throw NetworkError.unknownError(response)
        
    }catch (let error as Moya.MoyaError) {
        throw NetworkError.moyaError(error)
        
    }catch {
        throw NetworkError.unknownError(response)
    }
    
}

