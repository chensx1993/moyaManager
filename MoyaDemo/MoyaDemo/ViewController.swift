//
//  ViewController.swift
//  MoyaDemo
//
//  Created by 陈思欣 on 2019/5/7.
//  Copyright © 2019 chensx. All rights reserved.
//

import UIKit
import Moya

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        userLogin("chensx1993", password: "")
        testReques()
//        commonReques()
    }
    
    func testReques() {
        requestJson(GitHub.userProfile("chensx1993"), success: { (json) in
            print("\n\n=========json:\n\(json)\n============")
        }) { (error) in
            
        }
    }
    
    func commonReques() {
        let username = "chensx1993".urlEscaped
        let url = "https://api.github.com/users/\(username)"
        let parameters = ["sort": "pushed"]
        
        networking.requestNormal(.url2(url, parameters: parameters), success: { (response) in
            do {
                let json = try response.mapJSON()
                print("\(url): \(json)");
                
            } catch(let error) {
                self.showAlert("error", message: "mapping string error: \(error)");
            }
            
        }) { (error) in
            
        }
    }

    func userLogin(_ username: String, password: String) {
        
        userModuleProvider.request(.login(username: username, password: password)) { (result) in
            do {
                let response = try result.get()
                
            } catch {
                self.showAlert("error", message: "user login error")
            }
        }
    }
    
    fileprivate func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

