//
//  PlaylistView.swift
//  KBApp
//
//  Created by Sam Richard on 1/6/23.
//

import SwiftUI

struct PlaylistView: View {
    
    @State private var trackModel = [PlaylistTrackCellModel]()
    @State private var description = ""
    var model: FeaturedPlaylistCellModel
    
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
            
                AsyncImage(url: model.artworkURL) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: 220, maxHeight: 220)
                        .padding()
                        //.cornerRadius(15)
                } placeholder: {
                    ProgressView()
                }
                
                VStack(alignment: .leading){
                    Text(model.name)
                        .font(.title)
                        .bold()
                    Text(description)
                        .font(.subheadline)
                        .italic()
                }
                                                
            
                VStack(spacing: 5) {
                    
                    ForEach(trackModel) { model in
                        HStack {
                            
                            AsyncImage(url: model.artworkURL) { image in
                                image.resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(maxWidth: 35, maxHeight: 35)
                            } placeholder: {
                                ProgressView()
                            }
                            
                            
                            VStack() {
                                Text(model.name)
                                    //.font(.subheadline)
                                    .bold()
                                Text(model.artistName)
                                    //.font(.caption)
                            }
                            
                            Spacer()
                            
                        }
                        .padding()
                        .background(Color.gray.opacity(0.2))
                    }
                }.padding([.leading, .trailing], 5)
            }
            .onAppear {
                fetchData()
                AuthManager.shared.refreshIfNeeded(completion: nil)
            }
            
        }.navigationBarItems(
            trailing:
                NavigationLink(destination: PlayGameView()) {
                    Text("Play Game!")
                        .font(.subheadline)
                        .bold()
                        .foregroundColor(.white)
                        .frame(width: 100, height: 35)
                        .background(.blue)
                        .cornerRadius(5)
                }
        )//.navigationTitle(model.name)
    }
    
    private func updateUI(with model: PlaylistDetailsResponse) {
        description = model.description
        trackModel = model.tracks.items.compactMap({
            return PlaylistTrackCellModel(name: $0.track.name, id: $0.track.id, artistName: $0.track.artists.first?.name ?? "-", artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
        })
        
    }
    
    private func fetchData() {
        APICaller.shared.getPlaylistDetails(for: model.id) { result in
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

struct PlaylistView_Previews: PreviewProvider {
    static var model = FeaturedPlaylistCellModel(name: "New Music Friday", id: "37i9dQZF1DX4JAvHpjipBk", artworkURL: URL(string: "https://i.scdn.co/image/ab67706f000000031c493708e15d2df8910577df"))
    
    static var previews: some View {
        PlaylistView(model: model)
    }
}
