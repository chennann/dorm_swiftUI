//
//  checkDetail.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/19.
//

import SwiftUI

struct checkDetail: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var loginManager: LoginManager
    @State private var errorMessage: String?
    
    var check: Check
    @State private var appealReason: String = ""
    
    @State private var showCamera = false
    @State var appealImg: UIImage?
    @State var appealUrl: String?
    @State var IsLoading: Bool = false
    
    @StateObject private var keyboardManager = KeyboardManager()
    
    
    var body: some View {
        ZStack {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Color.orange)
                        .font(.system(size: 23, weight: .bold))
                })
                Spacer()
            }
            Text("申诉页面")
                .bold()
                .font(.system(size: 30))
        }
        .padding(.horizontal)
        ScrollView {
            VStack {
                
                HStack {
                    Text("📄扣分详情❌")
                        .bold()
                        .font(.system(size: 50))
                    Spacer()
                }
                .padding(30)
                RoundedRectangle(cornerRadius: 25)
                    .fill(Color.white) // 设置背景色
                    .frame(width: 350, height: 300) // 设置尺寸
                    .shadow(radius: 10) // 设置阴影
                    .overlay(
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                Text("🤡 学生用户名:")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text(" \(check.studentUserName)")
                            }
                            HStack {
                                Text("🔢 学生编号: ")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("\(check.studentNumber)")
                            }
                            
                            HStack {
                                Text("⏰ 扣分时间: ")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("\(check.checkTime)")
                            }
                            HStack {
                                Text("📜 扣分原因: ")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("\(check.checkReason)")
                            }
                            HStack {
                                Text("❗️ 扣分数值: ")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("\(check.checkValue)")
                            }
                            HStack {
                                Text("🙇🏻‍♂️ 状态: ")
                                    .bold()
                                    .font(.system(size: 20))
                                Spacer()
                                Text("\(check.status)")
                            }
                        }
                            .padding(.trailing, 50)
                            .padding(.leading, 30)
                    )
                    .padding(.bottom)
                
                HStack {
                    AsyncImage(url: URL(string: check.checkImg ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 350, height: 350)
                }
                Divider()
                HStack {
                    Text("🙋🏻‍♂️申诉👊")
                        .bold()
                        .font(.system(size: 50))
                    Spacer()
                }
                .padding(.horizontal, 30)
                TextField((check.status != "已扣分") ? "当前状态不可申诉" : "申诉原因", text: $appealReason) // 绑定到inputText
                    .padding()
                    .background(Color.white) // 设置背景色
                    .cornerRadius(5) // 设置圆角
                    .shadow(radius: 5) // 设置阴影
                    .padding(.horizontal, 30) // 设置水平填充
                    .disabled(check.status != "已扣分")
                
                Button {
                    self.showCamera = true
                } label: {
                    if appealUrl == nil {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(Color.gray)
                    }
                    else {
                        AsyncImage(url: URL(string: appealUrl ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                        } placeholder: {
                            ProgressView()
                        }
                        .frame(width: 150, height: 150)
                        .shadow(radius: 10) // 设置阴影
                    }
                    
                }
                .padding(.top)
                
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .fullScreenCover(isPresented: $showCamera) {
                CameraView(image: self.$appealImg)
                    .onDisappear(perform: {
                        
                        withAnimation {
                            IsLoading = true
                            appealUrl = ""
                        }
                        
                        let networkService = NetworkService()
                        networkService.uploadFile(image: appealImg ?? UIImage(imageLiteralResourceName: "info")){ result in
                            defer { IsLoading = false }
                            switch result {
                                
                            case .success(let response):
                                appealUrl = response.data
                            case .failure(let error):
                                self.errorMessage = error.localizedDescription
                            }
                        }
                    })
            }
        }
        Button {
            withAnimation {
                addAppeal()
                self.presentationMode.wrappedValue.dismiss()
            }
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill((check.status != "已扣分") ? Color.gray : Color.blue)
                .frame(width: 260, height: 60)
                .shadow(color: Color.blue, radius: (check.status != "已扣分") ? 0 : 5, x: 0, y: 0)
                .overlay {
                    Text("🙇‍♂️求求你别扣我分🙇")
                        .foregroundColor(Color.white)
                        .bold()
                        .font(.system(size: 20))
                }
        }
        .offset(y: keyboardManager.keyboardHeight>0 ? 200 : 0)
        .disabled(check.status != "已扣分")
    }
    
    func addAppeal () {
        let networkService = NetworkService()
        networkService.addAppealService(appeal: Appeal(checkId: check.id, appealReason: appealReason, appealImg: appealUrl ?? "")) { result in
            switch result {
            case .success(let response):
                print(response.msg)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                loginManager.logout()
            }
        }
    }
}

#Preview {
    checkDetail(check: Check(id: 1, studentUserName: "cnn", studentNumber: "2112222", checkTime: "2024-01-17 01:43:25", checkReason: "地面", checkValue: 2, status: "已扣分"))
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
