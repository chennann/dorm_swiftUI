//
//  Response.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import Foundation


struct Response<T: Codable>: Codable {
    var code: Int
    var msg: String
    var data: T
}

