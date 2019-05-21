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
        
        testRequestJson()
        commonReques()
    }

    func testRequestJson() {
        
        requestJson(GitHub.userProfile("chensx1993"), success: { (json) in
            print("\n\n=========json:\n\(json)\n============")
        }) { (error) in
            print("\n\n=========error:\n\(error)\n============")
        }
        
        gitHubNetworking.requestJson(.userProfile("chensx1993"), success: { (json) in
             print("\n\n=========gitHubNetworking json:\n\(json)\n============")
            
        }) { (error) in
            print("\n\n=========gitHubNetworking error:\n\(error)\n============")
        }
        
        gitHubNetworking.request(.userProfile("chensx1993"), success: { (response) in
            do {
                let json = try response.mapString()
                print("gitHubNetworking.request: \(json)");
                
            } catch(let error) {
                print("error: \(error)");
            }
        }) { (error) in
            
        }
    }
    
    func commonReques() {
        
        let username = "chensx1993".urlEscaped
        let url = "https://api.github.com/users/\(username)"
        let parameters = ["sort": "pushed"]
        
        networking.request(.url2(url, parameters: parameters), success: { (response) in
            do {
                let json = try response.mapJSON()
                print("test networking \(url): \(json)");
                
            } catch(let error) {
                print("error: \(error)");
            }
            
        }) { (error) in
            print("error: \(error)");
        }
        
    }
    

}

