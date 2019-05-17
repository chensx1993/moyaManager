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
//                self.showAlert("error", message: "mapping string error: \(error)");
            }
            
        }) { (error) in
            
        }
    }

}

