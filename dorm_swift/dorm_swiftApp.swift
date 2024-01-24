//
//  dorm_swiftApp.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

@main
struct dorm_swiftApp: App {
    var loginManager = LoginManager()
    var sharedModel = SharedModel()
    var body: some Scene {
        WindowGroup {
            MainView()
                .enableToast()
                .environmentObject(loginManager)
                .environmentObject(sharedModel)
        }
    }
}
