//
//  MainView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct MainView: View {
    
    init() {
        let appeareance = UITabBarAppearance()
        
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        UITabBar.appearance().backgroundColor = UIColor(Color("tab_background").opacity(0.7))
        appeareance.shadowColor = UIColor(Color.black)
        }
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var sharedModel: SharedModel
    
    
    var body: some View {
        NavigationView {
            if loginManager.isLoggedIn {
                if loginManager.role == "student" {
                    
                    studentView()
                }
                else {
                    
                    dormAdminView()
                }
            }
            else {
                LoginView()
            }
        }
    }
}

#Preview {
    MainView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
