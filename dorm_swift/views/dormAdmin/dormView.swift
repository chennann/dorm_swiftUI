//
//  dormView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI
import ExytePopupView

struct dormView: View {
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var loginManager: LoginManager
    @State private var errorMessage: String?
    
    @State var currentStep: Int = 1
    @State var totalMember: Int = 6
    @State private var students: [Student] = []
    
    @State var isloading: Bool = false
    
    @State private var balcony = 0
    @State private var rubbish = 0
    @State private var desk = 0
    @State private var floor = 0
    @State private var quilt = 0
    
    @State private var showCamera = false
    @State private var showCameraBalcony = false
    @State private var showCameraRubbish = false
    @State private var showCameraDesk = false
    @State private var showCameraFloor = false
    @State private var showCameraQuilt = false
    
    @State var balconyImg: UIImage?
    @State var rubbishImg: UIImage?
    @State var deskImg: UIImage?
    @State var floorImg: UIImage?
    @State var quiltImg: UIImage?
    
    @State var balconyUrl: String?
    @State var rubbishUrl: String?
    @State var deskUrl: String?
    @State var floorUrl: String?
    @State var quiltUrl: String?
    
    @State var balconyIsLoading: Bool = false
    @State var rubbishIsLoading: Bool = false
    @State var deskIsLoading: Bool = false
    @State var floorIsLoading: Bool = false
    @State var quiltIsLoading: Bool = false
    
    @State var finished: Bool  = false
    let scores = Array(0...5) // 分数的可选范围，从0到5
    
    
    var dormNumber: String
    
    
    var body: some View {
        VStack {
            if isloading {
                ProgressView()
            }
            else {
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
                    Text(dormNumber)
                        .bold()
                        .font(.system(size: 30))
                }
                .padding(.horizontal)
                //            Spacer()
                if students.count == 0 {
                    Spacer()
                    HStack {
                        Text("🎉")
                            .font(.system(size: 50))
                        VStack {
                            Text("该寝室当日")
                            Text("已全部完成查寝")
                        }
                        .bold()
                        .font(.system(size: 25))
                        Text("🎉")
                            .font(.system(size: 50))
                    }
                    .padding(.bottom, 100)
                    .padding(.top, 290)
                    Button {
                        withAnimation {
                            self.presentationMode.wrappedValue.dismiss()
                        }
                    } label: {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.blue)
                            .frame(width: 250, height: 50)
                            .overlay {
                                Text("确定")
                                    .foregroundColor(Color.white)
                                    .bold()
                                    .font(.system(size: 18))
                            }
                    }
                    .padding(.top, 250)
                }
                else {
                    VStack {
                        ProgressBarView(step: currentStep, totalStep: totalMember)
                        Text("\(currentStep) / \(totalMember)")
                    }
                    .padding()
                    
                    //                        ForEach(students, id: \.self) { student in
                    //                            Text(student.studentName)
                    //                        }
                    if finished {
                        VStack {
                            
                            HStack {
                                Image(systemName: "checkmark.circle")
                                    .foregroundColor(.green)
                                    .font(.system(size: 100))
                                VStack {
                                    Text("🛌\(dormNumber)🛌查寝完成")
                                    Text("🚀精彩的查寝")
                                }
                                .bold()
                                .font(.system(size: 20))
                            }
                            .padding(.top, 200)
                            Spacer()
                            Button {
                                withAnimation {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            } label: {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)
                                    .frame(width: 250, height: 50)
                                    .overlay {
                                        Text("确定")
                                            .foregroundColor(Color.white)
                                            .bold()
                                            .font(.system(size: 18))
                                    }
                            }
                            .padding(.bottom, 50)

                        }
                    }
                    else {
                        if students.indices.contains(currentStep-1) {
                            let student = students[currentStep-1]
                            HStack {
                                Text("学生姓名：")
                                    .bold()
                                Text(student.studentName)
                                Spacer()
                                Text("床号：")
                                    .bold()
                                Text("\(student.bedNumber)")
                                Spacer()
                                Text("学号：")
                                    .bold()
                                Text(student.studentNumber ?? "xxx")
                            }
                            .padding(.horizontal, 30)
                            ScrollView {
                                VStack(alignment: .leading, spacing: 10) {
                                    Divider()
                                    HStack {
                                        
                                        Text("阳台")
                                            .font(.title)
                                            .bold()
                                        Text("🏞️")
                                            .font(.system(size: 50))
                                        Spacer()
                                        Text("扣")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                        Picker("扣分", selection: $balcony) {
                                            ForEach(scores, id: \.self) { score in
                                                Text("\(score) ").tag(score)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle()) // 使用菜单样式
                                        .frame(width: 200, height: 80) // 限制Picker的宽度
                                        Text("分")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                    }
                                    .padding(.horizontal, 15)
                                    //                    Text("\(balcony)")
                                    if balcony != 0 && balconyUrl == nil {
                                        HStack () {
                                            Spacer()
                                            Text("扣分依据：")
                                            Button {
                                                self.showCameraBalcony = true
                                            } label: {
                                                
                                                Image(systemName: "camera.viewfinder")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(Color.gray)
                                            }
                                            
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 40)
                                        .fullScreenCover(isPresented: $showCameraBalcony) {
                                            CameraView(image: self.$balconyImg)
                                                .onDisappear(perform: {
                                                    
                                                    withAnimation {
                                                        balconyIsLoading = true
                                                        balconyUrl = ""
                                                    }
                                                    
                                                    let networkService = NetworkService()
                                                    networkService.uploadFile(image: balconyImg ?? UIImage(imageLiteralResourceName: "info")){ result in
                                                        defer { balconyIsLoading = false }
                                                        switch result {
                                                            
                                                        case .success(let response):
                                                            balconyUrl = response.data
                                                        case .failure(let error):
                                                            self.errorMessage = error.localizedDescription
                                                        }
                                                    }
                                                })
                                        }
                                    }
                                    if balconyUrl != nil {
                                        HStack {
                                            Spacer()
                                            
                                            AsyncImage(url: URL(string: balconyUrl ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 150, height: 150)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 30)
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("垃圾")
                                            .font(.title)
                                            .bold()
                                        Text("🗑️")
                                            .font(.system(size: 50))
                                        Spacer()
                                        Text("扣")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                        Picker("扣分", selection: $rubbish) {
                                            ForEach(scores, id: \.self) { score in
                                                Text("\(score) ").tag(score)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle()) // 使用菜单样式
                                        .frame(width: 200, height: 80) // 限制Picker的宽度
                                        Text("分")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                    }
                                    .padding(.horizontal, 15)
                                    //                    Text("\(rubbish)")
                                    if rubbish != 0 && rubbishUrl == nil {
                                        HStack () {
                                            Spacer()
                                            Text("扣分依据：")
                                            Button {
                                                self.showCameraRubbish = true
                                            } label: {
                                                
                                                Image(systemName: "camera.viewfinder")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(Color.gray)
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 40)
                                        .fullScreenCover(isPresented: $showCameraRubbish) {
                                            CameraView(image: self.$rubbishImg)
                                                .onDisappear(perform: {
                                                    
                                                    withAnimation {
                                                        rubbishIsLoading = true
                                                        rubbishUrl = ""
                                                    }
                                                    
                                                    let networkService = NetworkService()
                                                    networkService.uploadFile(image: rubbishImg ?? UIImage(imageLiteralResourceName: "info")){ result in
                                                        defer { rubbishIsLoading = false }
                                                        switch result {
                                                            
                                                        case .success(let response):
                                                            rubbishUrl = response.data
                                                        case .failure(let error):
                                                            self.errorMessage = error.localizedDescription
                                                        }
                                                    }
                                                })
                                        }
                                    }
                                    if rubbishUrl != nil {
                                        HStack {
                                            Spacer()
                                            
                                            AsyncImage(url: URL(string: rubbishUrl ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 150, height: 150)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 30)
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("桌面")
                                            .font(.title)
                                            .bold()
                                        Text("💻")
                                            .font(.system(size: 50))
                                        Spacer()
                                        Text("扣")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                        Picker("扣分", selection: $desk) {
                                            ForEach(scores, id: \.self) { score in
                                                Text("\(score) ").tag(score)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle()) // 使用菜单样式
                                        .frame(width: 200, height: 80) // 限制Picker的宽度
                                        Text("分")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                    }
                                    .padding(.horizontal, 15)
                                    //                    Text("\(desk)")
                                    if desk != 0 && deskUrl == nil {
                                        HStack () {
                                            Spacer()
                                            Text("扣分依据：")
                                            Button {
                                                self.showCameraDesk = true
                                            } label: {
                                                
                                                Image(systemName: "camera.viewfinder")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(Color.gray)
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 40)
                                        .fullScreenCover(isPresented: $showCameraDesk) {
                                            CameraView(image: self.$deskImg)
                                                .onDisappear(perform: {
                                                    
                                                    withAnimation {
                                                        deskIsLoading = true
                                                        deskUrl = ""
                                                    }
                                                    
                                                    let networkService = NetworkService()
                                                    networkService.uploadFile(image: deskImg ?? UIImage(imageLiteralResourceName: "info")){ result in
                                                        defer { deskIsLoading = false }
                                                        switch result {
                                                            
                                                        case .success(let response):
                                                            deskUrl = response.data
                                                        case .failure(let error):
                                                            self.errorMessage = error.localizedDescription
                                                        }
                                                    }
                                                })
                                        }
                                    }
                                    if deskUrl != nil {
                                        HStack {
                                            Spacer()
                                            
                                            AsyncImage(url: URL(string: deskUrl ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 150, height: 150)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 30)
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("地面")
                                            .font(.title)
                                            .bold()
                                        Text("🧹")
                                            .font(.system(size: 50))
                                        Spacer()
                                        Text("扣")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                        Picker("扣分", selection: $floor) {
                                            ForEach(scores, id: \.self) { score in
                                                Text("\(score) ").tag(score)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle()) // 使用菜单样式
                                        .frame(width: 200, height: 80) // 限制Picker的宽度
                                        Text("分")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                    }
                                    .padding(.horizontal, 15)
                                    //                    Text("\(floor)")
                                    if floor != 0 && floorUrl == nil {
                                        HStack () {
                                            Spacer()
                                            Text("扣分依据：")
                                            Button {
                                                self.showCameraFloor = true
                                            } label: {
                                                
                                                Image(systemName: "camera.viewfinder")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(Color.gray)
                                            }
                                            Spacer()
                                        }
                                        .padding(.horizontal, 40)
                                        .fullScreenCover(isPresented: $showCameraFloor) {
                                            CameraView(image: self.$floorImg)
                                                .onDisappear(perform: {
                                                    
                                                    withAnimation {
                                                        floorIsLoading = true
                                                        floorUrl = ""
                                                    }
                                                    
                                                    let networkService = NetworkService()
                                                    networkService.uploadFile(image: floorImg ?? UIImage(imageLiteralResourceName: "info")){ result in
                                                        defer { floorIsLoading = false }
                                                        switch result {
                                                            
                                                        case .success(let response):
                                                            floorUrl = response.data
                                                        case .failure(let error):
                                                            self.errorMessage = error.localizedDescription
                                                        }
                                                    }
                                                })
                                        }
                                    }
                                    if floorUrl != nil {
                                        HStack {
                                            Spacer()
                                            
                                            AsyncImage(url: URL(string: floorUrl ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 150, height: 150)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 30)
                                        
                                    }
                                    Divider()
                                    HStack {
                                        Text("被子")
                                            .font(.title)
                                            .bold()
                                        Text("🛏️")
                                            .font(.system(size: 50))
                                        Spacer()
                                        Text("扣")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                        Picker("扣分", selection: $quilt) {
                                            ForEach(scores, id: \.self) { score in
                                                Text("\(score) ").tag(score)
                                            }
                                        }
                                        .pickerStyle(SegmentedPickerStyle()) // 使用菜单样式
                                        .frame(width: 200, height: 80) // 限制Picker的宽度
                                        Text("分")
                                            .foregroundStyle(Color.gray)
                                            .bold()
                                    }
                                    .padding(.horizontal, 15)
                                    //                    Text("\(quilt)")
                                    if quilt != 0 && quiltUrl == nil {
                                        HStack () {
                                            Spacer()
                                            Text("扣分依据：")
                                            Button {
                                                self.showCameraQuilt = true
                                            } label: {
                                                
                                                Image(systemName: "camera.viewfinder")
                                                    .font(.system(size: 30))
                                                    .foregroundColor(Color.gray)
                                            }
                                            
                                            Spacer()
                                        }
                                        .padding(.horizontal, 40)
                                        .fullScreenCover(isPresented: $showCameraQuilt) {
                                            CameraView(image: self.$quiltImg)
                                                .onDisappear(perform: {
                                                    
                                                    withAnimation {
                                                        quiltIsLoading = true
                                                        quiltUrl = ""
                                                        
                                                    }
                                                    
                                                    let networkService = NetworkService()
                                                    networkService.uploadFile(image: quiltImg ?? UIImage(imageLiteralResourceName: "info")){ result in
                                                        defer { quiltIsLoading = false }
                                                        switch result {
                                                            
                                                        case .success(let response):
                                                            quiltUrl = response.data
                                                        case .failure(let error):
                                                            self.errorMessage = error.localizedDescription
                                                        }
                                                    }
                                                })
                                        }
                                    }
                                    if quiltUrl != nil {
                                        HStack {
                                            Spacer()
                                            
                                            AsyncImage(url: URL(string: quiltUrl ?? "https://roy064.oss-cn-shanghai.aliyuncs.com/library/75694086-f111-4c5b-ad7c-f2bff521c302.png")) { image in
                                                image.resizable()
                                                    .aspectRatio(contentMode: .fit)
                                            } placeholder: {
                                                ProgressView()
                                            }
                                            .frame(width: 150, height: 150)
                                            Spacer()
                                        }
                                        .padding(.horizontal, 30)
                                        
                                    }
                                    Divider()
                                }
                                .padding()
                            }
                        } else {
                            Text("No student information available.")
                        }
                        HStack {
        //                    Button(action: {
        //                        if currentStep > 1 {
        //                            currentStep -= 1
        //                        }
        //                    }) {
        //                        Text("Previous")
        //                    }
                            Spacer()
                            Button(action: {
                                addCheck(studentNumber: students[currentStep-1].studentNumber ?? "")
                                
                                if (currentStep == students.count) {
                                    withAnimation {
                                        finished = true
                                    }
                                }
                                else {
                                    showToast(content: "✅操作成功")
                                }
                                if currentStep < students.count {
                                    withAnimation {
                                        currentStep += 1
                                        dataClear()

                                    }
                                }
                                
                            }) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(RadialGradient(gradient: Gradient(colors: [Color.green, Color.yellow]), center: .topLeading, startRadius: 0, endRadius: 1700))
                                    .frame(width: 100, height: 50)
                                    .shadow(color: Color.green, radius: 5, x: 0 , y: 0)
                                    
                                
                                    .overlay(Image(systemName: "arrowshape.forward.fill")
                                        .foregroundColor(Color.white))
                                    .font(.title2)
                                    .bold()
                            }
                        }
                        .padding(.horizontal, 50)
                    }
                }
                
                Spacer()
            }
            
            
        }
        .onAppear(perform: {
            getStudentsByDorm()
        })
        .navigationBarBackButtonHidden(true)
    }
    
    func getStudentsByDorm () {
        withAnimation(nil) {
            isloading = true
        }
        
        let networkService = NetworkService()
        networkService.getStudentsByDormService(dormNumber: dormNumber) { result in
            defer { isloading = false }
            switch result {
            case .success(let response):
                self.students = response.data
                totalMember = students.count
            case .failure(let error):
                self.errorMessage = error.localizedDescription
                loginManager.logout()
            }
        }
    }
    
    func dataClear () {
        
        balcony = 0
        rubbish = 0
        desk = 0
        floor = 0
        quilt = 0
        
        
        balconyImg             = nil
        rubbishImg             = nil
        deskImg                = nil
        floorImg               = nil
        quiltImg               = nil
        
        balconyUrl             = nil
        rubbishUrl             = nil
        deskUrl                = nil
        floorUrl               = nil
        quiltUrl               = nil
        
        balconyIsLoading       = false
        rubbishIsLoading       = false
        deskIsLoading          = false
        floorIsLoading         = false
        quiltIsLoading         = false
    }
    
    func addCheck (studentNumber: String) {
        let networkService = NetworkService()
        networkService.addCheckService(check: CheckData(studentNumber: studentNumber, balcony: balcony, rubbish: rubbish, desk: desk, floor: floor, quilt: quilt, dailyPenaltyImageUrlForBalcony: balconyUrl ?? "", dailyPenaltyImageUrlForRubbish: rubbishUrl ?? "", dailyPenaltyImageUrlForDesk: deskUrl ?? "", dailyPenaltyImageUrlForFloor: floorUrl ?? "", dailyPenaltyImageUrlForQuilt: quiltUrl ?? "")) { result in
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
    dormView(dormNumber: "1208")
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
    
}
