//
//  ProfileView.swift
//  KBApp
//
//  Created by Sam Richard on 1/3/23.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
        .onAppear {
            APICaller.shared.getCurrentUserProfile { result in
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
