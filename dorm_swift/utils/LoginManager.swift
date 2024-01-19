//
//  LoginManager.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

class LoginManager: ObservableObject {
    
    @Published var username: String {
        didSet {
            UserDefaults.standard.set(username, forKey: "username")
        }
    }
    @Published var isLoggedIn: Bool {
        didSet {
            UserDefaults.standard.set(isLoggedIn, forKey: "isLoggedIn")
        }
    }
    @Published var token: String {
        didSet {
            UserDefaults.standard.set(token, forKey: "authToken")
        }
    }
    @Published var role: String {
        didSet {
            UserDefaults.standard.set(role, forKey: "role")
        }
    }
    init() {
        self.isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
        self.token = UserDefaults.standard.string(forKey: "authToken") ?? "default"
        self.role = UserDefaults.standard.string(forKey: "role") ?? "default"
        self.username = UserDefaults.standard.string(forKey: "username") ?? "default"
    }
    
    func logout () {
        isLoggedIn  = false
        token = ""
        role = ""
        username = ""
    }
}

