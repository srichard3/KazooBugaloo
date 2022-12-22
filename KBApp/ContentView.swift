//
//  ContentView.swift
//  KBApp
//
//  Created by Sam Richard on 12/17/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        if AuthManager.shared.isSignedIn {
            HomeScreen()
        } else {
            SignInScreen()
            
        }
        
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
