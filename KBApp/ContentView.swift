//
//  ContentView.swift
//  KBApp
//
//  Created by Sam Richard on 12/17/22.
//

import SwiftUI

struct ContentView: View {
    @State var isLoggedIn: Bool = false
    @State var refresh: Bool = false
    
    var body: some View {
        return Group {
                SignInScreen()
        }
        
    }

}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
