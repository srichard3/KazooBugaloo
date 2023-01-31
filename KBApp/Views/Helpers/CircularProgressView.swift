//
//  CircularProgressView.swift
//  KBApp
//
//  Created by Sam Richard on 1/30/23.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    var shadowColor: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    Color(.systemGray3).opacity(0.5),
                    lineWidth: 8
                )
                .frame(width: 290, height: 290)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.white,
                    style: StrokeStyle(
                        lineWidth: 8,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .frame(width: 290, height: 290)
                .shadow(color: shadowColor, radius: 5)
                .animation(.easeOut, value: progress)

        }
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 10, shadowColor: .green)
    }
}
