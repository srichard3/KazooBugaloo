//
//  HomeScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//
import SwiftUI


struct HomeScreen: View {
    @State private var showingSheet = false
    
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
                
                //VStack {
                    NavigationLink(destination: GameScreen()) {
                        Text("Play Game")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(maxWidth: 250, maxHeight: 70)
                            .background(.red)
                            .cornerRadius(20)
                            .padding()
                        
                    }.navigationBarBackButtonHidden(true)
                    
                Button {
                    showingSheet.toggle()
                } label: {
                    Text("How To Play")
                        .font(.title2)
                        .foregroundColor(.white)
                        .frame(maxWidth: 250, maxHeight: 70)
                        .background(.gray)
                        .cornerRadius(20)
                        .padding()
                }.sheet(isPresented: $showingSheet) {
                    HowToPlayView()
                }
//                    NavigationLink(destination: HowToPlayView()) {
//                        Text("How To Play")
//                            .font(.title2)
//                            .foregroundColor(.white)
//                            .frame(maxWidth: 250, maxHeight: 70)
//                            .background(.gray)
//                            .cornerRadius(20)
//                            .padding()
//
//                    }.navigationBarBackButtonHidden(true)
                //}

                Spacer()
            }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
