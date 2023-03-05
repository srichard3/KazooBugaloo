//
//  GameScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//
import SwiftUI

struct GameScreen: View {
    
    @State private var featuredModel = [FeaturedPlaylistCellModel]()
    @State private var userPlaylistModel = [FeaturedPlaylistCellModel]()
    @State private var userPlaylists = [Playlist]()
    @State private var KBModel = [FeaturedPlaylistCellModel]()
    @State private var userModel = [String]()
    
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            VStack(alignment: .leading) {
                
                Text("**Kazoo Bugaloo Playlists**").font(.title2).foregroundColor(Color.ui.blue).padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 20) {
                        
                        Spacer()
                        
                        ForEach(KBModel) { model in
                            VStack(alignment: .leading) {

                                NavigationLink(destination: PlaylistView(model: model)) {

                                    AsyncImage(url: model.artworkURL) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 200, maxHeight: 200)
                                            .cornerRadius(15)
                                    } placeholder: {
                                        ProgressView()
                                    }

                                }

                                Text(" " + model.name)
                                    .font(.footnote)

                                Spacer()

                            }
                        }
                    }
                }
                
                Spacer()
                
                Text("**Spotify Featured Playlists**").font(.title2).foregroundColor(Color.ui.blue).padding(.top)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(spacing: 20) {
                        
                        Spacer()
                        
                        ForEach(featuredModel) { model in
                            VStack(alignment: .leading) {
                                
                                NavigationLink(destination: PlaylistView(model: model)) {
                                    
                                    AsyncImage(url: model.artworkURL) { image in
                                        image.resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(maxWidth: 200, maxHeight: 200)
                                            .cornerRadius(15)
                                            .shadow(color: .white, radius: 5)
                                            .padding(.top)
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                }
                                
                                Text(" " + model.name)
                                    .font(.footnote)
                                    .foregroundColor(.white)
                                
                                Spacer()
                                
                            }
                        }
                    }
                }
                
                Spacer()
                
                Text("**Your Playlists**").font(.title2).foregroundColor(Color.ui.blue).padding()
                
                VStack(alignment: .leading, spacing: 2.5) {
                                        
                    ForEach(userPlaylists) { model in
                        
                        NavigationLink(
                            destination: PlaylistView(model: FeaturedPlaylistCellModel(
                                    name: model.name,
                                    id: model.id,
                                    artworkURL: URL(string: model.images.first?.url ?? ""
                            )))) {
                            
                            HStack {
                                
                                AsyncImage(url: URL(string: model.images.first?.url ?? "")) { image in
                                    image.resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(maxWidth: 35, maxHeight: 35)
                                        .shadow(color: .white, radius: 3)
                                } placeholder: {
                                    ProgressView()
                                }
                                
                                
                                VStack(alignment: .leading) {
                                    
                                    Text(model.name)
                                        .font(.callout)
                                        .bold()
                                        .frame(maxWidth: 250, maxHeight: 15, alignment: .leading)
                                        .truncationMode(.tail)
                                        .foregroundColor(.white)
                                    Text(model.owner.display_name)
                                        .font(.caption2)
                                        .foregroundColor(.white)
                                        .italic()
                                    
                                }.padding(.leading)
                                
                                Spacer()
                                
                            }
                            .padding()
                            .background(Color(.systemGray2).opacity(0.2))
                        }
                        
                        Spacer()
                        
                    }
                }.padding([.leading, .trailing], 8)
            
        }.onAppear {
            fetchData()
            fetchUserPlaylists()
            fetchKBData()
            AuthManager.shared.refreshIfNeeded(completion: nil)
        }.navigationBarItems(
            
            trailing:
                NavigationLink(destination: SettingsView())
            {
                Image(systemName: "gear")
            }
        ).navigationTitle("Select a Playlist")
    }
    }
    
    
    private func updateUI(with model: FeaturedPlaylistResponse) {
        
        featuredModel = model.playlists.items.compactMap({
            return FeaturedPlaylistCellModel(name: $0.name, id: $0.id, artworkURL: URL(string: $0.images.first?.url ?? ""))
        })
        
    }
    
    private func updateUserPlaylists(with model: UserPlaylistResponse) {
        
        userPlaylists = model.items
        userPlaylistModel = model.items.compactMap({
            return FeaturedPlaylistCellModel(name: $0.name, id: $0.id, artworkURL: URL(string: $0.images.first?.url ?? ""))
        })
        
    }
    
    
    private func fetchData() {
        APICaller.shared.getFeaturedPlaylists { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    updateUI(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
    }
    
    private func fetchUserPlaylists() {
        APICaller.shared.getUserPlaylists { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    updateUserPlaylists(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func fetchKBData() {
        KBModel.removeAll()
        APICaller.shared.getPlaylistDetails(for: KB_HIP_PLAYLIST_ID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    updateKBModel(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        APICaller.shared.getPlaylistDetails(for: KB_POP_PLAYLIST_ID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    updateKBModel(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        APICaller.shared.getPlaylistDetails(for: KB_ROCK_PLAYLIST_ID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    updateKBModel(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        APICaller.shared.getPlaylistDetails(for: KB_PLAYLIST_ID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    updateKBModel(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateKBModel(with model: PlaylistDetailsResponse) {
        KBModel.append(FeaturedPlaylistCellModel(name: model.name, id: model.id, artworkURL: URL(string: model.images.first?.url ?? "")))
    }
    
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}
