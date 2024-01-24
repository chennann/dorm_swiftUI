//
//  appealHandle.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct appealHandleView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @EnvironmentObject var sharedModel: SharedModel
    
//    @State var appeals: [AppealHandle] = [AppealHandle(id: 1, studentUserName: "", studentNumber: "", checkTime: "", checkReason: "", checkValue: 1, checker: "", status: ""), AppealHandle(id: 1, studentUserName: "", studentNumber: "", checkTime: "", checkReason: "", checkValue: 2, checker: "", status: ""), AppealHandle(id: 1, studentUserName: "", studentNumber: "", checkTime: "", checkReason: "", checkValue: 1, checker: "", status: "")]
    @State var appeals: [AppealHandle] = []
    
    @State private var loginResponse: Response<String?>?
    @State private var errorMessage: String?
    
    @State var isloading: Bool = false
    
    var stringMap = [String: String]()
    var stringMapInitialized = ["阳台": "🏞️阳台", "垃圾": "🗑️垃圾", "桌面": "💻桌面", "地面": "🧹地面", "被子": "🛌被子"]
    
    var body: some View {
        VStack {
            if isloading {
                ProgressView()
            }
            else {
                HStack {
                    Text("待处理申诉")
                        .bold()
                        .font(.system(size: 40))
                    Spacer()
                }
                .padding()
                
                if appeals.count == 0 {
                    Spacer()
                    VStack {
                        Image(systemName: "checkmark.circle")
                            .foregroundColor(.green)
                            .font(.system(size: 130))
                            .padding()
                        Text("👉没有待处理的申诉👈")
                        .bold()
                        .font(.system(size: 30))
                    }
                    .padding(.bottom, 90)
                    Spacer()
                }
                else {
                    List {
                        ForEach(appeals.indices, id: \.self) { index in
                            VStack(alignment: .center, spacing: 5) {
                                
                                HStack {
                                    Text("\(appeals[index].studentUserName)")
                                    Spacer()
                                    Text("\(appeals[index].studentNumber)")
                                }
                                .font(.system(size: 25))
                                .bold()
                                .padding(.horizontal, 30)
                                
                                HStack {
                                    Text("\(stringMapInitialized[appeals[index].checkReason] ?? "")扣\(appeals[index].checkValue)分")
                                }
                                .font(.system(size: 30))
                                Text("\(appeals[index].checkTime)")
                                HStack {
                                    Text("\(appeals[index].status)...")
                                        .italic()
                                        .foregroundStyle(Color.gray)
                                    Spacer()
                                    Button {
                                        withAnimation {
                                            appeals[index].showDetail.toggle()
                                        }
                                    } label: {
                                        Text("查看详情")
                                            .foregroundStyle(Color.gray)
                                    }
                                    .popover(isPresented: $appeals[index].showDetail) {
                                        
                                        HStack {
                                            Spacer()
                                            Text("📄申诉详情📄")
                                                .bold()
                                                .font(.system(size: 40))
                                                .padding()
                                            Spacer()
                                        }
                                        Divider()
                                        ScrollView {
                                            // 详细信息视图
                                            VStack(alignment: .leading, spacing: 10) {
                                        
                                                Text("扣分信息：")
                                                    .bold()
                                                    .font(.system(size: 30))
                                                Text("\(stringMapInitialized[appeals[index].checkReason] ?? "")扣\(appeals[index].checkValue)分")
                                                    .font(.system(size: 20))
                                                HStack {
                                                    Spacer()
                                                    AsyncImage(url: URL(string: appeals[index].checkImg ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                                        image.resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 350, height: 350)
                                                    Spacer()
                                                }
                                                Divider()
                                                Text("申诉信息：")
                                                    .bold()
                                                    .font(.system(size: 30))
                                                HStack {
                                                    Spacer()
                                                    RoundedRectangle(cornerRadius: 8)
                                                        .fill(Color.gray.opacity(0.2))
                                                        .frame(width: 350, height: 150)
                                                        .overlay {
                                                            Text(appeals[index].appealReason ?? "")
                                                                .foregroundColor(Color.black)
                                                                .font(.system(size: 20))
                                                        }
                                                    Spacer()
                                                }
                                                
                                                HStack {
                                                    Spacer()
                                                    AsyncImage(url: URL(string: appeals[index].appealImg ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                                        image.resizable()
                                                            .aspectRatio(contentMode: .fit)
                                                    } placeholder: {
                                                        ProgressView()
                                                    }
                                                    .frame(width: 350, height: 350)
                                                    Spacer()
                                                }
                                                Divider()
                                                HStack {
                                                    Spacer()
                                                    Button {
                                                        reject(id: appeals[index].id)
                                                        appeals[index].showDetail = false
                                                        appealList()
                                                    } label: {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color.red)
                                                            .frame(width: 150, height: 50)
                                                            .overlay {
                                                                Text("拒绝🙅")
                                                                    .foregroundColor(Color.white)
                                                                    .bold()
                                                                    .font(.system(size: 18))
                                                            }
                                                    }
                                                    
                                                    Button {
                                                        approve(id: appeals[index].id)
                                                        appeals[index].showDetail = false
                                                        appealList()
                                                    } label: {
                                                        RoundedRectangle(cornerRadius: 10)
                                                            .fill(Color.green)
                                                            .frame(width: 150, height: 50)
                                                            .overlay {
                                                                Text("同意🙆")
                                                                    .foregroundColor(Color.white)
                                                                    .bold()
                                                                    .font(.system(size: 18))
                                                            }
                                                    }
                                                    Spacer()
                                                }
                                                
                                                Spacer()
                                                
                                            }
                                            .padding()
                                        }
                                        
                                    }
                                }
                                .padding(.horizontal, 20)
                                
                            }
                            
                            
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    print("Left swipe action on \(appeals[index].id)")
                                    approve(id: appeals[index].id)
                                    appeals[index].showDetail = false
                                    appeals.remove(at: index)
                                    appealList()
                                    showToast(content: "🙆操作成功")
                                } label: {
                                    Label("同意", systemImage: "checkmark")
                                }
                                .tint(.green)
                            }
                            .swipeActions(edge: .leading, allowsFullSwipe: true) {
                                Button {
                                    print("Right swipe action on \(appeals[index].id)")
                                    reject(id: appeals[index].id)
                                    appeals[index].showDetail = false
                                    appeals.remove(at: index)
                                    appealList()
                                    showToast(content: "🙅拒绝成功")
                                } label: {
                                    Label("拒绝", systemImage: "xmark")
                                }
                                .tint(.red)
                            }
                        }
//                        .onDelete(perform: delete)
                    }
                }
            }
            
        }
        .onAppear(perform: {
            appealList()
        })
    }
    
    func reject (id: Int) {
//        withAnimation(nil) {
//            isloading = true
//        }
        
        let networkService = NetworkService()
        networkService.rejectService(appeal: AppealHandleSend(id: id)) { result in
            defer { appealList() }
            switch result {
            case .success(let response):
                print(response.msg)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                loginManager.logout()
            }
        }
    }
    
    func approve (id: Int) {
//        withAnimation(nil) {
//            isloading = true
//        }
        
        let networkService = NetworkService()
        networkService.approveService(appeal: AppealHandleSend(id: id)) { result in
            defer { appealList() }
            switch result {
            case .success(let response):
                print(response.msg)
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                loginManager.logout()
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        appeals.remove(atOffsets: offsets)
    }
    
    func appealList () {
        withAnimation(nil) {
//            isloading = true
        }
        
        let networkService = NetworkService()
        networkService.listAppealService(pageNum: 1, pageSize: 100, checkerUserName: UserDefaults.standard.string(forKey: "username") ?? "suguan") { result in
            defer { isloading = false }
            switch result {
            case .success(let response):
                self.appeals = response.data.items
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                loginManager.logout()
            }
        }
    }
}

#Preview {
    appealHandleView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
    
}
