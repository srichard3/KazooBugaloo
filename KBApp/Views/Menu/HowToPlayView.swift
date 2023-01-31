//
//  HowToPlayView.swift
//  KBApp
//
//  Created by Sam Richard on 1/19/23.
//

import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            VStack {
                Text("How To Play!")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.title2)
                        .frame(maxWidth: 250, maxHeight: 70)
                        .background(.white)
                        .cornerRadius(20)
                        .padding()
                }
                
            }
        }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
