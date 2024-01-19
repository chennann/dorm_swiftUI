//
//  checkList.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct checkList: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var sharedModel: SharedModel
    
    @State private var checks: [Check] = [Check(id: 1, studentUserName: "qwe", studentNumber: "q", checkTime: "123", checkReason: "asdasd", checkValue: 2, status: "aaa")]
    @State private var loginResponse: Response<String?>?
    @State private var errorMessage: String?
    @State private var student: Student?
    
    var stringMapInitialized = ["阳台": "🏞️阳台", "垃圾": "🗑️垃圾", "桌面": "💻桌面", "地面": "🧹地面", "被子": "🛌被子"]
    
    @State var isloading: Bool = false
    
    var body: some View {
        VStack {
            if isloading {
                ProgressView()
            }
            else {
                HStack {
                    Text("扣分列表：")
                        .bold()
                        .font(.system(size: 30))
                    Spacer()
                }
                .padding(.horizontal)
                .offset(y:checks.isEmpty ? -220 : 0)
                
                if !checks.isEmpty {
                    List(checks.filter { $0.status != "优秀" }, id: \.id) { check in
                        NavigationLink  {
                            checkDetail(check: check)
                        } label: {
                            HStack {
                                AsyncImage(url: URL(string: check.checkImg ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                            image.resizable()
                                                 .aspectRatio(contentMode: .fit)
                                        } placeholder: {
                                            ProgressView()
                                        }
                                        .frame(width: 100, height: 100)
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("扣分原因：   ")
                                            .font(.subheadline)
                                            .foregroundStyle(Color.gray)
                                        Text(stringMapInitialized[check.checkReason] ?? check.checkReason)
                                            .font(.system(size: 25))
                                    }
                                    HStack {
                                        Text("时间：")
                                            .font(.subheadline)
                                            .foregroundStyle(Color.gray)
                                        Text("\(check.checkTime)")
                                    }
                                    HStack {
                                        Text("扣分分值：        ")
                                            .font(.subheadline)
                                            .foregroundStyle(Color.gray)
                                        Text("\(check.checkValue)分")
                                            .foregroundStyle(Color.red)
                                    }
                                    HStack {
                                        Text("扣分状态：        ")
                                            .font(.subheadline)
                                            .foregroundStyle(Color.gray)
                                        Text("\(check.status)")
                                            .foregroundStyle(((check.status)=="申诉成功") ? Color.green : (((check.status)=="申诉失败") ? Color.red : ((check.status)=="申诉中") ? Color.orange : Color.black))
                                    }
                                }
                            }
                        }
                        .navigationBarBackButtonHidden(true)
                        
                        
                    }
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 200))
                        .bold()
                        .foregroundColor(Color.gray)
                }
            }
            
        }
        .onAppear(perform: {
            
            getStudentInfo()
            
            
//                doNothing()
        })
        .frame(height: 700)
    }
    
    func getStudentInfo () {
        withAnimation(nil) {
            isloading = true
        }
        
        let networkService = NetworkService()
        networkService.getStudentInfo(studentUserName: UserDefaults.standard.string(forKey: "username") ?? "chennann" ) { result in
            defer {
                isloading = false
                listChecks()
            }
            switch result {
            case .success(let response):
                self.student = response.data
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                loginManager.logout()
            }
        }
    }
    
    
    func listChecks () {
        
        withAnimation(nil) {
            isloading = true
        }
        
        let networkService = NetworkService()
        networkService.listCheckService(pageNum: 1, pageSize: 100, studentNumber: student?.studentNumber ?? "21120992" ) { result in
            defer { isloading = false }
            switch result {
            case .success(let response):
                self.checks = response.data.items
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                loginManager.logout()
            }
        }
        
    }
}

#Preview {
    checkList()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
