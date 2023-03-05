//
//  PlayGameView.swift
//  KBApp
//
//  Created by Sam Richard on 1/16/23.
//

import SwiftUI

enum PlayGameState {
    case startGame, inGame, indicateTurn, guessResult, roundBuffer, gameOver
}

//Default Kazoo Bugaloo Playlist
let KB_PLAYLIST_ID = "2xyefiz6KVuPDEV86qTJzf"
let KB_HIP_PLAYLIST_ID = "58sHWCySNEvsAcQsTFwkbV"
let KB_ROCK_PLAYLIST_ID = "4v18Kkh8sVyHl7703MV1mC"
let KB_POP_PLAYLIST_ID = "0eLqj1DFJoQYQyLzCr5tCE"
let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
let scoreToWin = 5
let WON_BLURBS = ["Nice Job!", "Good Work!", "Beautiful!", "Keep it up!"]
let LOSS_BLURBS = ["Nice try!", "That one was tough!", "Better luck next time!", "Keep trying!"]
let PASS_BLURBS = ["What song was that?", "Pass!", "Come on, you knew that one!", "How does that song go?"]

struct PlayGameView: View {
    @State var playGameState: PlayGameState = .startGame
    @State var randomTrack = PlaylistTrackCellModel(name: "", id: "", artistName: "", artworkURL: URL(string: ""))
    @State var lastSongResult: Int = 0
    @State private var progress = 1.0
    @State private var count = 10.0
    @State var shadowColor: Color = .green
    @State var timeOut: Bool = false
    @State var scores: [Int] = []
    @State var pointsThisRound = 0
    @State var playerIndex = 0
    @State var KBModel: [PlaylistTrackCellModel] = []
    @State var trackModel = [PlaylistTrackCellModel]()
    var numberOfPlayers: Int
    @State var players = [Player]()
    @State var teamOne = [Player]()
    @State var teamTwo = [Player]()
    @State var teamOneScore: Int = 0
    @State var teamTwoScore: Int = 0
    var isTeamPlay: Bool
    @State var gameWinner: Player = Player(id: "", name: "", score: 0)
    @State var teamWinner: [Player] = [Player(id: "", name: "", score: 0)]
    @State var showName: Bool = true
    @State var showNext: Bool = false
    @State var passes: Int = 0
    @State var isTeamOnesTurn: Bool = true
    
    
    var body: some View {
        ZStack {
            switch playGameState {
            case .startGame:
                Button {
                    playerIndex = 0
                    if isTeamPlay {
                        while (playerIndex < teamOne.count) {
                            teamOne[playerIndex].score = 0
                            playerIndex += 1
                        }
                        playerIndex = 0
                        while (playerIndex < teamTwo.count) {
                            teamTwo[playerIndex].score = 0
                            playerIndex += 1
                        }
                    } else {
                        while (playerIndex < players.count) {
                            players[playerIndex].score = 0
                            playerIndex += 1
                        }
                    }
                    playerIndex = 0
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
                }.shadow(color: .green, radius: 6)
                
            case .indicateTurn:
                VStack {
                    Spacer()
                    
                    if isTeamPlay {
                        if isTeamOnesTurn {
                            Text("Team 1")
                                .font(.system(size: 70))
                                .bold()
                                .foregroundColor(.black)
                                .shadow(color: Color.ui.blue, radius: 10)
                                .padding()
                            
                            Spacer()
                            
                            Text("It's \(teamOne[playerIndex].name)'s turn to hum!")
                                .italic()
                                .font(.title2)
                        } else {
                            Text("Team 2")
                                .font(.system(size: 70))
                                .bold()
                                .foregroundColor(.black)
                                .shadow(color: Color.ui.blue, radius: 10)
                                .padding()
                            
                            Spacer()
                            
                            Text("It's \(teamTwo[playerIndex].name)'s turn to hum!")
                                .italic()
                                .font(.title2)
                        }
                    } else {
                        Text("It's \(players[playerIndex].name)'s turn to hum!")
                            .italic()
                            .font(.title2)
                        
                    }
                    
                    Button {
                        showName = true
                        showNext = false
                        startRound()
                    } label: {
                        Text("Begin Round")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: 250, maxHeight: 70)
                            .background(Color.ui.blue)
                            .cornerRadius(20)
                            .padding()
                    }.shadow(color: Color.ui.blue, radius: 6)
                    
                    Spacer()
                    
                }.transition(STATE_TRANSITION)
            case .inGame:
                VStack {
                    Spacer()
                    
                    AsyncImage(url: randomTrack.artworkURL) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxWidth: 220, maxHeight: 220)
                            .padding()
                            .shadow(color: .gray, radius: 8)
                            .cornerRadius(15)
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
                                    .shadow(color: .gray, radius: 6)
                                    .padding()
                                
                                Text("Time's up!")
                                    .font(.title)
                                    .bold()
                                    .foregroundColor(.red)
                                    .cornerRadius(20)
                                
                                Button {
                                    guessComplete(result: 0)
                                } label: {
                                    Text("Continue")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.red)
                                        .frame(maxWidth: 200, maxHeight: 70)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(20)
                                        .padding()
                                    
                                }.shadow(color: Color(.systemGray5), radius: 6)
                                
                                Spacer()
                            }
                        } else {
                            CircularProgressView(progress: progress, shadowColor: shadowColor)
                                .onReceive(timer) { _ in
                                    progress -= 0.025
                                    count -= 0.5
                                    if progress <= 0.0 || count <= 0 {
                                        timer.upstream.connect().cancel()
                                        withAnimation { timeOut = true }
                                    }
                                    
                                    if progress < 0.075 {
                                        shadowColor =  .red
                                    } else if progress < 0.15 {
                                        shadowColor = .yellow
                                    } else {
                                        shadowColor = .green
                                    }
                                }
                            
                            VStack {
                                Button {
                                    pointsThisRound += 1
                                    guessComplete(result: 1)
                                } label: {
                                    Image(systemName: "checkmark")
                                        .font(.title)
                                        .bold()
                                        .foregroundColor(.white)
                                        .frame(maxWidth: 160, maxHeight: 100)
                                        .background(.green)
                                        .cornerRadius(20)
                                }.shadow(color: .green, radius: 6)
                                
                                Button {
                                    passes += 1
                                    guessComplete(result: 2)
                                } label: {
                                    Text("Pass")
                                        .font(.title2)
                                        .bold()
                                        .foregroundColor(.red)
                                        .frame(maxWidth: 100, maxHeight: 50)
                                        .background(Color(.systemGray5))
                                        .cornerRadius(20)
                                        .padding()
                                    
                                }.shadow(color: Color(.systemGray5), radius: 6)
                            }
                        }
                    }
                    .padding()
                    .navigationBarItems(
                        trailing:
                            Text("Points This Round: \(pointsThisRound)")
                                .font(.subheadline)
                                .bold()
                                .foregroundColor(.black)
                                .frame(width: 180, height: 30)
                                .shadow(color: .blue, radius: 6)
                                .background(.blue)
                                .opacity(0.6)
                                .cornerRadius(8)
                    )
                    
                }.onAppear {
                    newSong()
                    fetchKBData()
                }.transition(STATE_TRANSITION)
            case .guessResult:
                switch lastSongResult {
                case 0:
                    VStack {
                        Text(LOSS_BLURBS.randomElement() ?? "Next time!")
                            .italic()
                            .font(.title2)
                        
                        Button {
                            endRound()
                        } label: {
                            Text("End Turn")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.red)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(Color(.systemGray5))
                                .cornerRadius(20)
                                .padding()
                        }.shadow(color: Color(.systemGray5), radius: 6)
                    }
                case 1:
                    VStack {
                        Text(WON_BLURBS.randomElement() ?? "Nice Work!")
                            .italic()
                            .font(.title2)
                        
                        Button {
                            withAnimation { playGameState = .inGame }
                        } label: {
                            Text("Continue")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(Color.ui.blue)
                                .cornerRadius(20)
                                .padding()
                        }
                    }
                case 2:
                    VStack {
                        Text("Passes remaining: \(3 - passes)")
                            .italic()
                            .font(.title2)
                        
                        Button {
                            withAnimation { playGameState = .inGame }
                        } label: {
                            Text("Continue")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(Color.ui.blue)
                                .cornerRadius(20)
                                .padding()
                        }.shadow(color: Color.ui.blue, radius: 6)
                    }
                case 4:
                    VStack {
                        Text("No more passes:(")
                            .italic()
                            .font(.title2)
                        
                        Button {
                            endRound()
                        } label: {
                            Text("End Turn")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.red)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(Color(.systemGray5))
                                .cornerRadius(20)
                                .padding()
                        }.shadow(color: Color(.systemGray5), radius: 6)
                    }
                default:
                    Text("Something went wrong lol.\nMaybe restart the app?")
                }
                
            case .roundBuffer:
                if showName {
                    ZStack {
//                            Image(systemName: "star.fill")
//                                .font(.system(size: 800))
//                                .foregroundColor(.yellow)
//                                .shadow(color: .yellow, radius: 6)
                        if isTeamPlay {
                            if isTeamOnesTurn {
                                Text("Nice work \(teamOne[playerIndex].name)!").lineLimit(nil)
                                    .bold()
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .shadow(color: Color.ui.blue, radius: 6)
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                            withAnimation(.easeInOut(duration: 2.75)) {
                                                showName = false
                                            }
                                        }
                                    }
                            } else {
                                Text("Nice work \(teamTwo[playerIndex].name)!").lineLimit(nil)
                                    .bold()
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .padding()
                                    .shadow(color: Color.ui.blue, radius: 6)
                                    .onAppear {
                                        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                            withAnimation(.easeInOut(duration: 2.75)) {
                                                showName = false
                                            }
                                        }
                                    }
                            }
                        } else {
                            Text("Nice work \(players[playerIndex].name)!").lineLimit(nil)
                                .bold()
                                .font(.title)
                                .foregroundColor(.white)
                                .padding()
                                .shadow(color: Color.ui.blue, radius: 6)
                                .onAppear {
                                    Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { timer in
                                        withAnimation(.easeInOut(duration: 2.75)) {
                                            showName = false
                                        }
                                    }
                                }
                        }
                    }
                } else {
                    VStack {
                        Spacer()
                        
                        Text("SCORE")
                            .font(.headline)
                            .foregroundColor(.green)
                            .shadow(color: .green, radius: 6)
                        
                        if pointsThisRound == 0 {
                            Text("\(pointsThisRound)")
                                .bold()
                                .font(.system(size: 250))
                                .foregroundColor(.red)
                                .shadow(color: .red, radius: 6)
                        } else {
                            Text("\(pointsThisRound)")
                                .bold()
                                .font(.system(size: 250))
                                .foregroundColor(.green)
                                .shadow(color: .green, radius: 6)
                        }
                        
                        if isTeamPlay {
                            if isTeamOnesTurn {
                                Text("Team Score: \(teamOneScore)")
                                    .italic()
                                    .font(.caption)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            showNext = true
                                        }
                                    }
                            } else {
                                Text("Team Score: \(teamTwoScore)")
                                    .italic()
                                    .font(.caption)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                            showNext = true
                                        }
                                    }
                            }
                        } else {
                            Text("Total Score: \(players[playerIndex].score)")
                                .italic()
                                .font(.caption)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        showNext = true
                                    }
                                }
                        }
                        
                        Spacer()
                        if isTeamPlay {
                            if isTeamOnesTurn {
                                if teamOneScore >= scoreToWin {
                                    Text("You've won the game!")
                                        .italic()
                                        .foregroundColor(.yellow)
                                        .font(.subheadline)
                                        .opacity(showNext ? 1.0 : 0)
                                        .animation(
                                            .easeIn(duration: 1)
                                        )
                                } else {
                                    if playerIndex > (teamTwo.count - 1) {
                                        Text("Pass the phone to \(teamTwo[0].name)!")
                                            .italic()
                                            .foregroundColor(.blue)
                                            .font(.subheadline)
                                            .opacity(showNext ? 1.0 : 0)
                                            .animation(
                                                .easeIn(duration: 1)
                                            )
                                    } else {
                                        Text("Pass the phone to \(teamTwo[playerIndex].name)!")
                                            .italic()
                                            .foregroundColor(.blue)
                                            .font(.subheadline)
                                            .opacity(showNext ? 1.0 : 0)
                                            .animation(
                                                .easeIn(duration: 1)
                                            )
                                    }
                                }
                            } else {
                                if teamTwoScore >= scoreToWin {
                                    Text("You've won the game!")
                                        .italic()
                                        .foregroundColor(.yellow)
                                        .font(.subheadline)
                                        .opacity(showNext ? 1.0 : 0)
                                        .animation(
                                            .easeIn(duration: 1)
                                        )
                                } else {
                                    if playerIndex >= (teamOne.count - 1) {
                                        Text("Pass the phone to \(teamOne[0].name)!")
                                            .italic()
                                            .foregroundColor(.blue)
                                            .font(.subheadline)
                                            .opacity(showNext ? 1.0 : 0)
                                            .animation(
                                                .easeIn(duration: 1)
                                            )
                                    } else {
                                        Text("Pass the phone to \(teamOne[playerIndex + 1].name)!")
                                            .italic()
                                            .foregroundColor(.blue)
                                            .font(.subheadline)
                                            .opacity(showNext ? 1.0 : 0)
                                            .animation(
                                                .easeIn(duration: 1)
                                            )
                                    }
                                }
                            }
                        } else {
                            if players[playerIndex].score >= scoreToWin {
                                Text("You've won the game!")
                                    .italic()
                                    .foregroundColor(.yellow)
                                    .font(.subheadline)
                                    .opacity(showNext ? 1.0 : 0)
                                    .animation(
                                        .easeIn(duration: 1)
                                    )
                            } else {
                                if playerIndex == (players.count - 1) {
                                    Text("Pass the phone to \(players[0].name)!")
                                        .italic()
                                        .foregroundColor(.blue)
                                        .font(.subheadline)
                                        .opacity(showNext ? 1.0 : 0)
                                        .animation(
                                            .easeIn(duration: 1)
                                        )
                                } else {
                                    Text("Pass the phone to \(players[playerIndex + 1].name)!")
                                        .italic()
                                        .foregroundColor(.blue)
                                        .font(.subheadline)
                                        .opacity(showNext ? 1.0 : 0)
                                        .animation(
                                            .easeIn(duration: 1)
                                        )
                                }
                            }
                        }
                    
                        Button {
                            if isTeamPlay {
                                if isTeamOnesTurn {
                                    if teamOneScore >= scoreToWin {
                                        gameOverTeams(winner: teamOne)
                                    } else {
                                        if playerIndex > (teamTwo.count - 1) {
                                            playerIndex = 0
                                        }
                                        withAnimation { playGameState = .indicateTurn }
                                    }
                                } else {
                                    if teamTwoScore >= scoreToWin {
                                        gameOverTeams(winner: teamTwo)
                                    } else {
                                        
                                        if playerIndex >= (teamOne.count - 1) {
                                            playerIndex = 0
                                        } else {
                                            playerIndex += 1
                                        }
                                        withAnimation { playGameState = .indicateTurn }
                                    }
                                }
                                isTeamOnesTurn.toggle()
                            } else {
                                if players[playerIndex].score >= scoreToWin {
                                    gameOver(winner: players[playerIndex])
                                } else {
                                    
                                    if playerIndex == (players.count - 1) {
                                        playerIndex = 0
                                    } else {
                                        playerIndex += 1
                                    }
                                    withAnimation { playGameState = .indicateTurn }
                                }
                            }
                        } label: {
                            Text("Continue")
                                .font(.title2)
                                .bold()
                                .foregroundColor(.black)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(Color.ui.blue)
                                .cornerRadius(20)
                                .padding()
                                .opacity(showNext ? 1.0 : 0)
                                .animation(
                                    .easeIn(duration: 1)
                                )
                        }.shadow(color: Color.ui.blue, radius: 6)
                    }.navigationBarItems(
                        trailing:
                            NavigationLink(destination: HomeScreen()) {
                                Text("Cancel Game")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.black)
                                    .frame(width: 100, height: 30)
                                    .background(.red)
                                    .animation(
                                        .easeIn(duration: 3)
                                    )
                                    .cornerRadius(8)
                            }
                            .opacity(0.5)
                            .shadow(color: .red, radius: 3)
                            
                    )
                }
            case .gameOver:
                VStack {
                    
                    Spacer()
                    
                    Text("Game over!")
                        .font(.system(size: 70))
                        .bold()
                        .foregroundColor(.blue)
                        .shadow(color: Color.ui.blue, radius: 4)
                        .padding()
                    
                    if isTeamPlay {
                        if teamWinner == teamOne {
                            Text("Team 1 wins with \(teamOneScore) points!")
                                .font(.subheadline)
                                .italic()
                        } else {
                            Text("Team 2 wins with \(teamTwoScore) points!")
                                .font(.subheadline)
                                .italic()
                        }
                    } else {
                        Text("\(gameWinner.name) wins with \(gameWinner.score) points!")
                            .font(.subheadline)
                            .italic()
                    }
                    
                    Spacer()
                    
                    NavigationLink(destination: HomeScreen()) {
                        Text("Exit")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: 250, maxHeight: 70)
                            .background(Color.ui.blue)
                            .cornerRadius(20)
                            .padding()
                    }.shadow(color: Color.ui.blue, radius: 6)
                    
                    Button {
                        withAnimation { playGameState = .startGame }
                    } label: {
                        Text("Play Again")
                            .font(.title2)
                            .bold()
                            .foregroundColor(.black)
                            .frame(maxWidth: 250, maxHeight: 70)
                            .background(.green)
                            .cornerRadius(20)
                            .padding()
                    }.shadow(color: .green, radius: 6)
                }
            }
        }.navigationBarBackButtonHidden()
        
    }
    
    private func startRound() {
        pointsThisRound = 0
        passes = 0
        withAnimation { playGameState = .inGame }
    }
    
    private func endRound() {
        if isTeamPlay {
            if isTeamOnesTurn {
                teamOne[playerIndex].score += pointsThisRound
                teamOneScore += pointsThisRound
            } else {
                teamTwo[playerIndex].score += pointsThisRound
                teamTwoScore += pointsThisRound
            }
        } else {
            players[playerIndex].score += pointsThisRound
        }
        withAnimation { playGameState = .roundBuffer }
        
    }
    
    private func gameOver(winner: Player) {
        gameWinner = winner
        withAnimation { playGameState = .gameOver }
    }
    
    private func gameOverTeams(winner: [Player]) {
        teamWinner = winner
        withAnimation { playGameState = .gameOver }
    }
    
    private func guessComplete(result: Int) {
        if passes >= 3 {
            lastSongResult = 4
        } else {
            lastSongResult = result
        }
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
                    updateUI(with: model)
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
