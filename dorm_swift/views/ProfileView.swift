//
//  ProfileView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    var body: some View {
        VStack {
            
            VStack {
                Text(loginManager.token)
                Text(loginManager.role)
            }
            
            Button {
                loginManager.logout()
            } label: {
                Text("logout")
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(LoginManager())
}
