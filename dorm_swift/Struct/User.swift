//
//  userInfo.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import Foundation

struct User: Codable {
    
    var id: Int
    var username: String
    var nickname: String
    var email: String
    var userPic: String
    var createTime: String
    var updateTime: String
    var role: Int
    
}
