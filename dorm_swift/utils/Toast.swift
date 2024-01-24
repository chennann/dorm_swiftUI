//
//  Toast.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/24.
//


import SwiftUI

import ExytePopupView

/// extension 顾名思义即扩展
/// extension 可以给指定的对象、类型、struct、protocol 等扩展 func，不用再在具体的结构里面显式声明方法
/// 很好的一个横向解耦方式，很像PHP中的 Trait
/// 假如以后有相同方法的两个view，我们完全可以抽象到一起
extension View{
    
    // 初始化启动Toast 返回一个 some View
    public func enableToast() -> some View{
        @AppStorage("showGlobalToast") var showGlboalToast:Bool = false;
        @AppStorage("globalToastText") var globalToastText:String = "";
        // 这里将全局变量重置，以避免正好在显示Toast的时候退出了app
        // 导致下次打开app的时候就有一个 Toast
        showGlboalToast = false
        globalToastText = ""
        // 这里调用了一个view modifier
        return self.modifier(initToast())
    }
    
    // 显示一个Toast，传入内容
    public func showToast(content:String){
        @AppStorage("showGlobalToast") var showGlboalToast:Bool = false;
        @AppStorage("globalToastText") var globalToastText:String = "";
        
        // 修改全局变量
        showGlboalToast = true;
        globalToastText = content;
    }
}

/// view modifier 相当于在外面修改某个视图的结构
/// body方法中提供了一个content就是调用你的那个视图
/// 你也可以理解为这是在跳转页面，但是把原始页面的实例给你了
struct initToast:ViewModifier{
    
    @AppStorage("showGlobalToast") var showGlboalToast:Bool = false;
    @AppStorage("globalToastText") var globalToastText:String = "";
    
    public func body(content: Content) -> some View {
        // 直接给 content 调用popup
        content.popup(isPresented: $showGlboalToast, type:.toast, position: .bottom, animation: .easeInOut(duration: 0), autohideIn: 1, dragToDismiss: false,closeOnTap: false,closeOnTapOutside: true,backgroundColor: .clear
        ){
            HStack {

                Text(globalToastText)
                    .bold()
                    .font(.system(size: 20))
                    
            }
            .frame(width: 150, height: 100)
            .background(Color("cus_gray").opacity(1))
            .foregroundColor(.black)
            .cornerRadius(15.0)
            .position(x: 215, y: 400)
        }
    }
}
