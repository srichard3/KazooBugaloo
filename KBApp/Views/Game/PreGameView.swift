//
//  PreGameView.swift
//  KBApp
//
//  Created by Sam Richard on 1/19/23.
//

import SwiftUI

enum PreGameState {
    case playerCount, selectMode, inputNames
}

let STATE_TRANSITION = AnyTransition.asymmetric(
    insertion: .move(edge: .bottom).combined(with: .opacity),
    removal: .move(edge: .top).combined(with: .opacity)
)

struct PreGameView: View {
    @State var preGameState: PreGameState = .playerCount
    @State private var numberOfPlayers: Int = 1
    @State private var players = [String]()
    @State private var teamOne = [String]()
    @State private var teamTwo = [String]()
    @State private var tempName: String = ""
    @State private var isTeamPlay: Bool = false
    var trackModel = [PlaylistTrackCellModel]()
    
    

        var body: some View {
            ZStack {
                switch preGameState {
                case .playerCount:
                    VStack() {
                        Text("How many people are playing?")
                            .font(.title3)
                        
                        Picker("Number of Players", selection: $numberOfPlayers) {
                            ForEach(0...20, id: \.self) { numberOfPlayers in
                                Text("\(numberOfPlayers)")
                            }
                        }
                        .pickerStyle(.wheel)
                        
                        if numberOfPlayers >= 2 {
                            Button {
                                withAnimation { preGameState = .selectMode }
                            } label: {
                                Text("Continue")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: 250, maxHeight: 70)
                                    .background(.blue)
                                    .cornerRadius(20)
                                    .padding()
                            }
                        }
                    }.transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                    
                case .inputNames:
                    
                    if isTeamPlay {
                        
                    } else {
                        VStack {
                            if players.count < numberOfPlayers {
                                Spacer()
                                
                                Text("Submit player names:")
                                    .font(.title)
                                
                                List {
                                    
                                    TextField("Enter name...", text: $tempName)
                                        .onSubmit {
                                            players.append(tempName)
                                        }.modifier(ClearTextFieldButton(text: $tempName))
                                    
                                }
                            } else {
                                Spacer()
                                
                                Text("All players submitted!")
                                    .bold()
                                    .font(.title)
                                    
                                VStack {
                                    Button {
                                        withAnimation { players.removeAll() }
                                    } label: {
                                        Text("Re-enter names")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: 250, maxHeight: 70)
                                            .background(.gray)
                                            .cornerRadius(20)
                                            .padding()
                                    }
                                    
                                    NavigationLink(destination: PlayGameView(trackModel: trackModel, numberOfPlayers: numberOfPlayers, players: players, teamOne: teamOne, teamTwo: teamTwo, isTeamPlay: isTeamPlay)) {
                                        Text("Continue")
                                            .font(.title2)
                                            .foregroundColor(.white)
                                            .frame(maxWidth: 250, maxHeight: 70)
                                            .background(.blue)
                                            .cornerRadius(20)
                                            .padding()
                                    }
                                }.padding()
                            }
                            
                            Spacer()
                            
                            ScrollView {
                                Text("Players:")
                                    .bold()
                                    .font(.title2)
                                
                                Divider()
                                
                                if players.count == 0 {
                                    Text("There are no players yet...")
                                        .italic()
                                        .font(.caption)
                                }
                                
                                ForEach(players, id: \.self) { player in
                                    HStack {
                                        Text(player)
                                            .font(.title3)
                                            .bold()
                                            .foregroundColor(.black)
                                        
                                        Button {
                                            if let index = players.firstIndex(of: player) {
                                                players.remove(at: index)
                                            }
                                        } label: {
                                            Image(systemName: "trash")
                                                .foregroundColor(.red)
                                        }.padding()
                                        
                                    }.frame(maxWidth: 380, maxHeight: 60)
                                        .background(Color(.systemGray4))
                                        .cornerRadius(20)
                                        .padding()
                                    
                                }
                            }
                                                        
                        }.transition(STATE_TRANSITION)
                        
                    }
                    
                case .selectMode:
                    
                    VStack {
                        Text("Select Mode:")
                            .bold()
                            .font(.title)
                        
                        Button {
                            isTeamPlay = false
                            withAnimation { preGameState = .inputNames }
                        } label: {
                            Text("Free-For-All")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(.blue)
                                .cornerRadius(20)
                                .padding()
                        }
                        
                        Button {
                            isTeamPlay = true
                            withAnimation { preGameState = .inputNames }
                        } label: {
                            Text("Team Play")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(.blue)
                                .cornerRadius(20)
                                .padding()
                        }
                    }.padding()
                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))

                }
                
                
                //How many people are playing?
                
                
                //2 Players: Enter each player's name, no competition?
                
                //3 Players: Individual play forced - 1 points for guessing right, 1 point for humming right
                
                //4+ Players:
                //Team Play - each team gets a point per correctly guessed song
                //Enter team captain for each team
                //or
                //Individual Play - 1 points for guessing correct, 1 point for humming right
                //Enter all names
            }
        }
}

//struct PreGameView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        PreGameView()
//    }
//}
