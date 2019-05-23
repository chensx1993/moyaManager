//
//  UserProfileModel.swift
//  MoyaManager_Example
//
//  Created by hsbcnet.mobile.uk hsbcnet.mobile.uk on 2019/5/23.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import Foundation

struct UserProfileModel: Decodable {
    var avatar_url: String?
    var bio: String?
    var blog: String?
    var company: String?
    var created_at: String?
    var email: String?
    
    var events_url: String?
    var followers: Int
    var followers_url: String?
    var following: Int
    var following_url: String?
    var gists_url: String?
}
