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
                Spacer()
                Image("logo")
                    .resizable()
                    .frame(maxWidth: 350, maxHeight: 350)
                    .animation(
                        .easeInOut(duration: 1)
                            .repeatForever(autoreverses: true)
                    )
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
