//
//  appeal.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct appeal: View {
    var body: some View {
        ProfileView()
    }
}

#Preview {
    appeal()
        .environmentObject(LoginManager())
        .environmentObject(SharedModel())
}
