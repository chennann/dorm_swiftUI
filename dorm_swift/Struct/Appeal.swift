//
//  Appeal.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/19.
//

import Foundation

struct Appeal: Codable {
    var checkId: Int
    var appealReason: String
    var appealImg: String
}

struct AppealHandleData: Codable {
    var total: Int
    var items: [AppealHandle]
}

struct AppealHandle: Codable, Identifiable, Hashable {
    var idd = UUID()
    var id: Int
    var studentUserName: String
    var studentNumber: String
    var checkTime: String
    var checkReason: String
    var checkImg: String?
    var checkValue: Int
    var checker: String
    var appealReason: String?
    var appealImg: String?
    var status: String
    var showDetail: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case id, studentUserName, studentNumber, checkTime, checkReason, checkImg, checkValue, checker, appealReason, appealImg, status
    }
}

struct AppealHandleSend: Codable {
    var id: Int
    var checkValue: Int = 0
}
