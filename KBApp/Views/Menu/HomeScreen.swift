//
//  HomeScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//
import SwiftUI

//extension Color {
//    static let ui = Color.UI()
//                                             
//    struct UI {
//        let blue = Color("lightBlue")
//    }
//}

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
                            .foregroundColor(.black)
                            .frame(maxWidth: 250, maxHeight: 70)
                            .background(Color.ui.blue)
                            .shadow(color: .white, radius: 20)
                            .cornerRadius(20)
                            .padding()
                        
                    }.shadow(color: Color.ui.blue, radius: 10).navigationBarBackButtonHidden(true)
                    
                Button {
                    showingSheet.toggle()
                } label: {
                    Text("How To Play")
                        .font(.title2)
                        .foregroundColor(.black)
                        .frame(maxWidth: 250, maxHeight: 70)
                        .background(.gray)
                        .cornerRadius(20)
                        .padding()
                }.sheet(isPresented: $showingSheet) {
                    HowToPlayView()
                }.shadow(color: .gray, radius: 10)

                Spacer()
            }
                                             
    }

}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
