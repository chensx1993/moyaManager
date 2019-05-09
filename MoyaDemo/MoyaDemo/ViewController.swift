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
        
        userLogin("chensx1993", password: "")
        commonReques()
    }
    
    func commonReques() {
        networking.request(.url("https://api.github.com/zen"), success: { (response) in
            do {
                let json = try response.mapString()
                print("\(json)");
                
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

