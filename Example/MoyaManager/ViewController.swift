//
//  ViewController.swift
//  MoyaManager
//
//  Created by chensx on 05/07/2019.
//  Copyright (c) 2019 chensx. All rights reserved.
//

import UIKit
import MoyaManager

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        testRequestModel()
        testRequestJson()
        commonReques()
    }

    func testRequestModel() {
        
        gitHubNetworking.request(.userProfile("chensx1993"), success: { (response) in
            do {
                let model = try response.map(UserProfileModel.self)
                print("gitHubNetworking.request: \(model)");
                
            } catch(let error) {
                print("error: \(error)");
            }
        }) { (error) in
            
        }
    }
    
    
    func testRequestJson() {
        
        gitHubNetworking.requestJson(.userProfile("chensx1993"), success: { (json) in
            print("\n\n=========gitHubNetworking json:\n\(json)\n============")
            
        }) { (error) in
            print("\n\n=========gitHubNetworking error:\n\(error)\n============")
        }
        
    }
    
    func commonReques() {
        
        let username = "chensx1993".urlEscaped
        let url = "https://api.github.com/users/\(username)"
        let parameters = ["sort": "pushed"]
        
        
        Network.get(url, parameters: parameters, headers: nil, callbackQueue: DispatchQueue.main, progress: { (progress) in
            
        }, success: { (response) in
            do {
                let json = try response.mapJSON()
                print("test post \(url): \(json)");
                
            } catch(let error) {
                print("error: \(error)");
            }
        }) { (error) in
            print("error: \(error)");
        }
    }
        
}
