//
//  ProfileView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct ProfileView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    var roleMap = ["dormAdmin": "👩🏻‍💼宿管", "student": "👨🏼‍🎓学生", "waterStation": "💦水站"]
    
    var body: some View {
        VStack {
            HStack {
                if (UserDefaults.standard.string(forKey: "userPic") != "default") && (UserDefaults.standard.string(forKey: "userPic") != "") {
                    AsyncImage(url: URL(string: UserDefaults.standard.string(forKey: "userPic") ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.black, lineWidth: 5))
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
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
                VStack (alignment: .leading) {
                    Text(UserDefaults.standard.string(forKey: "username") ?? "UserName")
                        .bold()
                        .font(.system(size: 30))
                        .padding(.bottom, 1)
                    Text(UserDefaults.standard.string(forKey: "nickname") ?? "nickname")
                        .foregroundStyle(Color.gray)
                }
                .padding(.leading, 10)
                Spacer()
            }
            .padding(.horizontal, 30)
            .padding(.top, 50)
            .padding(.bottom, 10)
            VStack {
//                Text(loginManager.token)
//                Text(loginManager.role)
                HStack {
                    Text("🆔身份：")
                        .bold()
                        .font(.system(size: 60))
                    Spacer()
                }
                .padding(.horizontal, 30)
                .padding(.bottom, 100)
                Text(roleMap[loginManager.role] ?? loginManager.role)
                    .font(.system(size: 80))
                    .padding(.bottom, 90)
            }
            Spacer()
            Button {
                loginManager.logout()
            } label: {
                Text("退出登录")
                    .frame(width: 200)
                    .bold()
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.red)
                    .cornerRadius(10)
            }
            .padding(.bottom, 30)
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(LoginManager())
}
