//
//  HomeScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//
import SwiftUI


struct HomeScreen: View {
    var body: some View {
            VStack {
                
                Image("logo")
                    .frame(maxWidth: 270, maxHeight: 450)
                    .padding()
                Spacer()
                
                
                NavigationLink(destination: GameScreen()) {
                    Text("Play Game")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: 250, maxHeight: 70)
                        .background(.red)
                        .cornerRadius(20)
                        .padding()
                }.navigationBarBackButtonHidden(true)
                
                Spacer()
            }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
