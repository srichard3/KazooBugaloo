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

    
    var body: some View {
        
        Text("Sign-In Screen")
        
        Button {
            showWebView.toggle()
//            completionHandler = { [weak self] success in
//                self?.handleSignIn(success: success)
//            }
        } label: {
            Text("Spotify Authentification")
        }
        .sheet(isPresented: $showWebView) {
            Display()
        }
        
    }
    
//    private func handleSignIn(success: Bool) {
//
//    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}


