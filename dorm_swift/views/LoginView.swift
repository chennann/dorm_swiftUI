//
//  LoginView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct LoginView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    
    @State private var loginResponse: Response<String?>?
    @State private var errorMessage: String?
    
//    @State private var lNumber: String = ""
//    @State private var lName: String = ""
//    @State private var rId: String = ""
//    @State private var rPwd: String = ""
    @State private var username: String = ""
    @State private var password: String = ""
    
    
    @State var showPassword: Bool = false
    @State var isloading: Bool = false
    
    @State var str: String = ""
    
    var userRoles = [1: "dormAdmin", 2: "waterStation", 3: "student"]
    
    var body: some View {
        ZStack {
            
            RadialGradient(gradient: Gradient(colors: [Color.orange, Color.red]), center: .topTrailing, startRadius: 80, endRadius: 600)
                .ignoresSafeArea()
            
            VStack {
                
                HStack {
                    Text("登陆")
                        .font(.system(size: 60))
                        .bold()
                        .foregroundColor(.white)
                    
                    Spacer()
                }
                .frame(width: 300)
                
                
                
                VStack (spacing: 20) {
                    TextField("username", text: $username)
                        .frame(width: 320, height: 25)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 8)
                        .background(Color.white.opacity(0.9))
                        .cornerRadius(8)
                        .padding()
                    ZStack(alignment: .trailing) {
                        if showPassword {
                            TextField("password", text: $password)
                                .frame(width: 320, height: 25)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(8)
                        } else {
                            SecureField("password", text: $password)
                                .frame(width: 320, height: 25)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 8)
                                .background(Color.white.opacity(0.9))
                                .cornerRadius(8)
                            
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(showPassword ? .gray : .gray)
                        }
                        .padding(.trailing, 10)
                    }
                    
                    
                    
                    
                }
                .padding(.horizontal, 50)
                .padding(.vertical, 30)
                
                
//                                if let response = loginResponse {
//                                    Text("Code: \(response.code)")
//                                    Text("Message: \(response.msg)")
//                                    Text("Data: \(response.data ?? "")")
//                                    Text("role: \(loginManager.role)")
//                                } else if let errorMessage = errorMessage {
//                                    Text("Error: \(errorMessage)")
//                                }
                Text(str)
                
                
                Button(action: {
                    withAnimation(nil) {
                        isloading = true
                    }
                    let networkService = NetworkService()
                    
                    
                    networkService.login(username: username, password: password) { result in
                        defer { 
                            isloading = false
                            getUserInfo()
                        }
                        switch result {
                        case .success(let response):
                            self.loginResponse = response
                            if response.code == 1 {
                                loginManager.token = response.data ?? ""
                                loginManager.isLoggedIn = true
                                loginManager.username = username
                            }
                            else {
                                str = response.msg
                            }
                        case .failure(let error):
                            self.errorMessage = error.localizedDescription
                        }
                    }
                    
                }) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.yellow)
                        .frame(width: 200, height: 50)
                        .overlay (
                            HStack (spacing: 15) {
                                if isloading {
                                    Text("登录中...")
                                        .foregroundColor(Color.black)
                                        .bold()
                                        .font(.system(size: 20))
                                    ProgressView()
                                }
                                else {
                                    Text("登录")
                                        .foregroundColor(Color.black)
                                        .bold()
                                        .font(.system(size: 20))
                                }
                            }
                        )
                    
                }
                .frame(width: 200)
            }
            .padding()
        }
    }
    
    func getUserInfo () {
        let networkService = NetworkService()
        networkService.getUserInfo() { result in
            defer { isloading = false }
            switch result {
            case .success(let response):
                if response.code == 1 {
                    loginManager.role = userRoles[response.data.role] ?? "dormAdmin"
                }
                else {
                    str = response.msg
                }
            case .failure(let error):
                self.errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
