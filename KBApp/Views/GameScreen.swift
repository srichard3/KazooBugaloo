//
//  GameScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//
import SwiftUI

struct GameScreen: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("*Game Screen*")
                NavigationLink(destination: ProfileView()) {
                    Text("Profile")
                }
            }
        }
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}
