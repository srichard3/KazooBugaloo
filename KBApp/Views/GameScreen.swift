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
                
            }
        }
        .navigationBarItems(
            trailing:
                NavigationLink(destination: SettingsView())
                {
                    Image(systemName: "gear")
                }
        )
    }
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}
