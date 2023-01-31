//
//  PlayGameView.swift
//  KBApp
//
//  Created by Sam Richard on 1/16/23.
//

import SwiftUI

enum PlayGameState {
    case startGame, inGame, indicateTurn, guessResult
}

//Default Kazoo Bugaloo Playlist
let KB_PLAYLIST_ID = ""
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()


struct PlayGameView: View {
    @State var playGameState: PlayGameState = .startGame
    @State var randomTrack = PlaylistTrackCellModel(name: "", id: "", artistName: "", artworkURL: URL(string: ""))
    @State var lastSongCorrect: Bool = false
    @State private var progress = 1.0
    @State private var count = 10.0
    @State var shadowColor: Color = .green
    @State var timeOut: Bool = false
    @State var KBModel: [PlaylistTrackCellModel] = []
    @State var trackModel = [PlaylistTrackCellModel]()
    var numberOfPlayers: Int
    var players = [String]()
    var teamOne = [String]()
    var teamTwo = [String]()
    var isTeamPlay: Bool
    
    
    var body: some View {
        if isTeamPlay {
            
        } else {
            ZStack {
                switch playGameState {
                case .startGame:
                    Button {
                        withAnimation { playGameState = .indicateTurn }
                    } label: {
                        Text("Start Game")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.white)
                            .frame(maxWidth: 250, maxHeight: 70)
                            .background(.green)
                            .cornerRadius(20)
                            .padding()
                    }
                case .indicateTurn:
                    VStack {
                        Text("It's ___'s turn to hum!")
                            .italic()
                            .font(.title2)
                        
                        Button {
                            startRound()
                        } label: {
                            Text("Continue")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.white)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(.blue)
                                .cornerRadius(20)
                                .padding()
                        }
                    }
                case .inGame:
                    VStack {
                        Spacer()
                        
                        AsyncImage(url: randomTrack.artworkURL) { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(maxWidth: 220, maxHeight: 220)
                                .padding()
                                .shadow(color: .gray, radius: 8)
                            //.cornerRadius(15)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Text(randomTrack.name)
                            .font(.title2)
                            .bold()
                            .font(.headline)
                        
                        Text(randomTrack.artistName)
                            .italic()
                            .font(.headline)
                            .foregroundColor(Color(.systemGray))
                        
                        Spacer()
                        
                        ZStack {
                            if timeOut {
                                VStack {
                                    Image(systemName: "xmark")
                                        .font(.system (size: 150))
                                        .bold()
                                        .foregroundColor(.red)
                                        .cornerRadius(20)
                                        .padding()
                                    
                                    Text("Time's up!")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.red)
                                        .cornerRadius(20)
                                    
                                    Button {
                                        guessComplete(correct: false)
                                    } label: {
                                        Text("Continue")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.red)
                                            .frame(maxWidth: 250, maxHeight: 70)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(20)
                                            .padding()
                                        
                                    }
                                }
                            } else {
                                CircularProgressView(progress: progress, shadowColor: shadowColor)
                                    .onReceive(timer) { _ in
                                        progress -= 0.05
                                        count -= 0.5
                                        if progress <= 0.0 || count <= 0 {
                                            timer.upstream.connect().cancel()
                                            withAnimation { timeOut = true }
                                        }
                                        
                                        if progress < 0.15 {
                                            shadowColor =  .red
                                        } else if progress < 0.3 {
                                            shadowColor = .yellow
                                        } else {
                                            shadowColor = .green
                                        }
                                    }
                                
                                VStack {
                                    Button {
                                        guessComplete(correct: true)
                                    } label: {
                                        Image(systemName: "checkmark")
                                            .font(.title)
                                            .bold()
                                            .foregroundColor(.white)
                                            .frame(maxWidth: 160, maxHeight: 100)
                                            .background(.green)
                                            .cornerRadius(20)
                                    }
                                    Button {
                                        guessComplete(correct: false)
                                    } label: {
                                        Text("Pass")
                                            .font(.title2)
                                            .bold()
                                            .foregroundColor(.red)
                                            .frame(maxWidth: 100, maxHeight: 50)
                                            .background(Color(.systemGray5))
                                            .cornerRadius(20)
                                            .padding()
                                        
                                    }
                                }
                            }
                        }.padding()
                        
                    }.onAppear {
                        newSong()
                        fetchKBData()
                    }
                case .guessResult:
                    if lastSongCorrect {
                        VStack {
                            Text("Oh yeah!")
                                .italic()
                                .font(.title2)
                            
                            Button {
                                startRound()
                            } label: {
                                Text("Continue")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 250, maxHeight: 70)
                                    .background(.blue)
                                    .cornerRadius(20)
                                    .padding()
                            }
                        }
                    } else {
                        VStack {
                            Text("Yikes")
                                .italic()
                                .font(.title2)
                            
                            Button {
                                startRound()
                            } label: {
                                Text("Continue")
                                    .font(.title2)
                                    .bold()
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 250, maxHeight: 70)
                                    .background(.blue)
                                    .cornerRadius(20)
                                    .padding()
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    private func startRound() {
        
        withAnimation { playGameState = .inGame }
    }
    
    private func guessComplete(correct: Bool) {
        lastSongCorrect = correct
        progress = 1.0
        count = 10
        shadowColor = .green
        withAnimation { playGameState = .guessResult }
        timeOut = false
    }
    
    private func newSong() {
        if trackModel.count > 0 {
            randomTrack = trackModel.randomElement() ?? PlaylistTrackCellModel(name: "", id: "", artistName: "", artworkURL: URL(string: ""))
            if let index = trackModel.firstIndex(of: randomTrack) {
                trackModel.remove(at: index)
            }
        } else {
            randomTrack = KBModel.randomElement() ?? PlaylistTrackCellModel(name: "", id: "", artistName: "", artworkURL: URL(string: ""))
            if let index = KBModel.firstIndex(of: randomTrack) {
                KBModel.remove(at: index)
            }
        }
    }
    
    private func fetchKBData() {
        APICaller.shared.getPlaylistDetails(for: KB_PLAYLIST_ID) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print(model)
                    //updateUI(with: model)
                    break
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    private func updateUI(with model: PlaylistDetailsResponse) {
        KBModel = model.tracks.items.compactMap({
            return PlaylistTrackCellModel(name: $0.track.name, id: $0.track.id, artistName: $0.track.artists.first?.name ?? "-", artworkURL: URL(string: $0.track.album?.images.first?.url ?? ""))
        })
        
    }
    
}

//struct PlayGameView_Previews: PreviewProvider {
//    static var previews: some View {
//        PlayGameView()
//    }
//}
