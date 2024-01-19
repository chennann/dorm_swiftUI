//
//  Check.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/19.
//

import Foundation

struct CheckData: Codable {
    var studentNumber: String
    var checkTime: String
    var balcony: Int
    var rubbish: Int
    var desk: Int
    var floor: Int
    var quilt: Int
    var dailyPenaltyImageUrlForBalcony: String
    var dailyPenaltyImageUrlForRubbish: String
    var dailyPenaltyImageUrlForDesk: String
    var dailyPenaltyImageUrlForFloor: String
    var dailyPenaltyImageUrlForQuilt: String

    init(studentNumber: String, balcony: Int, rubbish: Int, desk: Int, floor: Int, quilt: Int, dailyPenaltyImageUrlForBalcony: String, dailyPenaltyImageUrlForRubbish: String, dailyPenaltyImageUrlForDesk: String, dailyPenaltyImageUrlForFloor: String, dailyPenaltyImageUrlForQuilt: String) {
        
        // 创建DateFormatter
        let formatter = DateFormatter()
        // 设置时间格式
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        // 获取当前时间并转化为字符串
        let currentDateTimeString = formatter.string(from: Date())
        
        self.studentNumber = studentNumber
        self.checkTime = currentDateTimeString
        self.balcony = balcony
        self.rubbish = rubbish
        self.desk = desk
        self.floor = floor
        self.quilt = quilt
        self.dailyPenaltyImageUrlForBalcony = dailyPenaltyImageUrlForBalcony
        self.dailyPenaltyImageUrlForRubbish = dailyPenaltyImageUrlForRubbish
        self.dailyPenaltyImageUrlForDesk = dailyPenaltyImageUrlForDesk
        self.dailyPenaltyImageUrlForFloor = dailyPenaltyImageUrlForFloor
        self.dailyPenaltyImageUrlForQuilt = dailyPenaltyImageUrlForQuilt
    }
}


struct CheckList: Codable {
    var total: Int
    var items: [Check]
}


struct Check: Codable, Identifiable, Hashable {
    var iid = UUID()
    var id: Int
    var studentUserName: String
    var studentNumber: String
    var checkTime: String
    var checkReason: String
    var checkImg: String?
    var checkValue: Int
    var checker: String?
    var appealReason: String?
    var appealImg: String?
    var status: String
    
    private enum CodingKeys: String, CodingKey {
        case id, studentUserName, studentNumber, checkTime, checkReason, checkImg, checkValue, checker, appealReason, appealImg, status
    }
}

