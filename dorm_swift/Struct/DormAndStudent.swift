//
//  DormAndStudent.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import Foundation

struct Dorm: Codable {
    var code: Int
    var msg: String
    var data: [Student]
}

struct Student: Codable, Identifiable, Hashable {
    var id = UUID()
    var studentId: Int
    var studentName: String
    var dormNumber: String
    var location: String?
    var bedNumber: Int
    var phone: String?
    var email: String?
    var studentNumber: String?
    var password: String?
    
    private enum CodingKeys: String, CodingKey {
        case studentId, studentName, dormNumber, location, bedNumber, phone, email, studentNumber, password
    }
}
