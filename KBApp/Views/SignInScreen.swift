//
//  SignInScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//

import SwiftUI
import WebKit

extension View {
    func toAnyView() -> AnyView {
        AnyView(self)
    }
}

public var completionHandler: ((Bool) -> Void)?

struct SignInScreen: View {
    @State private var showWebView = false
    @State private var showLoading: Bool = false
    @State var isLoggedIn: Bool = false
    
    
    var body: some View {
        
        Text("Sign-In Screen")
        
        if isLoggedIn {
            NavigationView {
                VStack {
                    Text("You have successfully signed in!")
                    NavigationLink(destination: HomeScreen()) {
                        Text("Continue")
                    }
                }
            }
        } else {
            Button {
                showWebView.toggle()
                print("LOGINVAL - \($isLoggedIn)")
                //            completionHandler = { [weak self] success in
                //                self?.handleSignIn(success: success)
                //            }
            } label: {
                Text("Spotify Authentification")
            }
            .sheet(isPresented: $showWebView) {
                Display(isLoggedIn: $isLoggedIn)
            }
        }
        
        
    }
    
//    private func handleSignIn(success: Bool) {
//        guard success else {
//            return
//        }
//
//        HomeScreen()
//    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}


