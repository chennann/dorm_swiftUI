//
//  Check.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct CheckView: View {
    
    @EnvironmentObject var loginManager: LoginManager
    @State private var errorMessage: String?
    
    var dorms: [String] = ["1208", "1210", "1212", "1211"]
    
    var body: some View {
        VStack {
            HStack {
                Text("寝室")
                    .bold()
                    .font(.system(size: 40))
                Spacer()
            }
            .padding()
            List {
                
                Section(header: Text("12楼")) {
                    ForEach(dorms, id: \.self) { dormNumber in
                        NavigationLink(destination: dormView(dormNumber: dormNumber)) {
                            Text(dormNumber)
                        }
                    }
                }
                Section(header: Text("11楼")) {
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("1101")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("1102")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("1103")
                    }
                }
                Section(header: Text("10楼")) {
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("1001")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("1002")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("1003")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("1004")
                    }
                }
                Section(header: Text("9楼")) {
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("901")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("902")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("903")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("904")
                    }
                    NavigationLink(destination: dormView(dormNumber: "1208")) {
                        Text("905")
                    }
                }
            }
        }
        
    }
}

#Preview {
    CheckView()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
