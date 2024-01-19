//
//  studentView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct studentView: View {
    var body: some View {
        VStack {
            TopView()
            
            TabView {
                checkList()
                .tabItem {
                    Image(systemName: "list.bullet.clipboard")
                    Text("扣分列表")
                }
                // MARK: - 新书入库
                appeal()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("我的")
                    }
            }
        }
    }
}

#Preview {
    studentView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
