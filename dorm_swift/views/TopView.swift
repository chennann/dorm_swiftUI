//
//  TopView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct TopView: View {
    
    @EnvironmentObject var sharedModel: SharedModel
    @EnvironmentObject var loginManager: LoginManager
    
    @State private var showUser = false
    @State private var showMenu = false
    
    var body: some View {
        ZStack {
            Text("查房系统")
                .foregroundColor(Color.white)
                .font(.title)
                .bold()
                .italic()
            HStack {
                Button (action:{
                    withAnimation {
                        sharedModel.showSearchBar.toggle()
                    }
                }) {
                    Image(systemName: "line.horizontal.3")
                        .bold()
                        .foregroundColor(Color.white)
                }
                Spacer()
                Button (action:{
                    showUser = true;
                }) {
                    
                    if (UserDefaults.standard.string(forKey: "userPic") != "default") && (UserDefaults.standard.string(forKey: "userPic") != "") {
                        AsyncImage(url: URL(string: UserDefaults.standard.string(forKey: "userPic") ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 2))
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 35, height: 35)
                    }
                    else {
                        if (loginManager.role == "dormAdmin") {
                            Image(systemName: "person.badge.key.fill")
                                .font(.system(size: 30))
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(.trailing, 5)
                        }
                        else {
                            Image(systemName: "person.fill")
                                .font(.system(size: 30))
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color.white.opacity(0.6))
                                .padding(.trailing, 5)
                        }
                    }
                    
                    
                    
                    
                }
                .sheet(isPresented: $showUser) {
                    ProfileView()
                }
            }
            .padding(.top, 5)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 5)
        .background(Color("Top_color"))
    }
}

#Preview {
    TopView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}

