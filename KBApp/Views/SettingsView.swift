//
//  SettingsView.swift
//  KBApp
//
//  Created by Sam Richard on 1/3/23.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {

            List {
                NavigationLink {
                    ProfileView()
                } label: {
                    Text("Profile")
                }
            }
            .navigationTitle("Settings")
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
