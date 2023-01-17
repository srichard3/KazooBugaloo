//
//  GameScreen.swift
//  KBApp
//
//  Created by Sam Richard on 12/20/22.
//
import SwiftUI

struct GameScreen: View {
    
    @State private var featuredModel = [FeaturedPlaylistCellModel]()
    
    var body: some View {
                
        VStack(alignment: .leading) {
            
            
            Text("**Spotify Featured Playlists**").font(.title2).padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    Spacer()
                    
                    ForEach(featuredModel) { model in
                        VStack {
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
                            
                            VStack(alignment: .leading) {
                                Text(model.name)
                                    .font(.callout)
                            }
                            
                            Spacer()
                        }
                    }
                }
            }
            .onAppear {
                fetchData()
                AuthManager.shared.refreshIfNeeded(completion: nil)
            }
        }.navigationBarItems(
            trailing:
                NavigationLink(destination: SettingsView())
                {
                    Image(systemName: "gear")
                }
        ).navigationTitle("")
        
    }
    
    private func updateCell(with model: FeaturedPlaylistCellModel) {
        
    }
    
    private func updateUI(with model: FeaturedPlaylistResponse) {
        
        featuredModel = model.playlists.items.compactMap({
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
}

struct GameScreen_Previews: PreviewProvider {
    static var previews: some View {
        GameScreen()
    }
}
