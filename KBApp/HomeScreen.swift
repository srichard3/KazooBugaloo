//
//  HomeScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//

import SwiftUI


struct HomeScreen: View {
    var body: some View {
        NavigationView {
            List{
                NavigationLink("Start") {
                    GameScreen()
                }
            }
        }
    }
}

struct HomeScreen_Previews: PreviewProvider {
    static var previews: some View {
        HomeScreen()
    }
}
