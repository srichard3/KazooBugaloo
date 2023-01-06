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
                Text("Welcome to Home")
                NavigationLink(destination: GameScreen()) {
                    Text("Play Game")
                }
            }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
