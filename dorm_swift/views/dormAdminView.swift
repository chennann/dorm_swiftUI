//
//  dormAdminView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct dormAdminView: View {
    var body: some View {
        VStack {
            TopView()
            
            TabView {
                CheckView()
                .tabItem {
                    Image(systemName: "bed.double")
                    Text("查寝")
                }
                appealHandleView()
                    .tabItem {
                        Image(systemName: "questionmark.bubble")
                        Text("申诉处理")
                    }
            }
        }
    }
}

#Preview {
    dormAdminView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
