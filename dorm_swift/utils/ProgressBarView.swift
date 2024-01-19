//
//  ProgressBarView.swift
//  dorm_swift
//
//  Created by chennann on 2024/1/18.
//

import SwiftUI

struct ProgressBarView: View {
    
    var step: Int = 0
    var totalStep: Int = 4
    var colorSet: [Color] = [Color.green, Color.green, Color.green, Color.green, Color.green, Color.green]

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .foregroundColor(.gray)
                    .opacity(0.3)

                Rectangle()
                    .foregroundColor(colorSet[step])
                    .frame(width: (geometry.size.width / CGFloat(totalStep)) * CGFloat(step))
            }
        }
        .frame(height: 10)
        .cornerRadius(10)
        
//        Button {
//            withAnimation {
//                step = step + 1
//            }
//        } label: {
//            Text("+1")
//        }
//
//        Button {
//            withAnimation {
//                step = step - 1
//            }
//        } label: {
//            Text("-1")
//        }
    }
    
}

#Preview {
    ProgressBarView(step: 2, totalStep: 6)
}
