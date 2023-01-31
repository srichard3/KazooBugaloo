//
//  ProfileView.swift
//  KBApp
//
//  Created by Sam Richard on 1/3/23.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var profile = ""
    @State private var models = [String]()
    
    var body: some View {
        ScrollView {
            Text(profile)
                .foregroundColor(.red)
                .onAppear {
                    fetchProfile()
                }
            
            if !models.isEmpty {
                    VStack {
                        Text(models[0])
                        Divider()
                    }
                    
                    AsyncImage(url: URL(string: models[1])) { image in
                        image
                    } placeholder: {
                        ProgressView()
                    }.frame(
                        width: 96, height: 96, alignment: .center
                    ).offset(y: 170)
                    
            }
            
        }
        
    }
    
    private func updateUI(with model: UserProfile) {
        models.append(model.display_name)
        models.append(model.images.first?.url ?? "")
        models.append(model.id)
    }
    
    private func fetchProfile() {
        APICaller.shared.getCurrentUserProfile { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    profile = ""
                    updateUI(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                    profile = "Failed to load profile."
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
