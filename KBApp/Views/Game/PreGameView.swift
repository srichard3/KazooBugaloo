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
    @State private var players = [Player]()
    @State private var teamOne = [Player]()
    @State private var teamTwo = [Player]()
    @State private var tempName: String = ""
    @State private var isTeamPlay: Bool = false
    @State private var teamOneEnabled: Bool = true
    @State private var teamOneColor: Color = Color.ui.blue
    @State private var teamTwoColor: Color = Color.ui.lightGray
    @State private var textFieldColor: Color = .white
    @State private var teamFull: Bool = false
    @State private var maxTeamSize: Int = 0
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
                                    .foregroundColor(.black)
                                    .frame(maxWidth: 250, maxHeight: 70)
                                    .background(Color.ui.blue)
                                    .cornerRadius(20)
                                    .padding()
                            }.shadow(color: Color.ui.blue, radius: 6)
                        }
                    }.transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))
                    
                case .inputNames:
                    
                    if isTeamPlay {
                        VStack {
                            VStack {
                                Text("Select Team:")
                                    .bold()
                                    .font(.title2)
                                
                                HStack{
                                    Button {
                                        teamOneEnabled = true
                                        withAnimation {
                                            teamOneColor = Color.ui.blue
                                            teamTwoColor = Color.ui.lightGray
                                        }
                                    } label: {
                                        Text("Team 1")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: 130, maxHeight: 70)
                                            .background(teamOneColor)
                                            .cornerRadius(20)
                                            .padding()
                                    }.shadow(color: teamOneColor, radius: 6)
                                    
                                    Button {
                                        teamOneEnabled = false
                                        withAnimation {
                                            teamTwoColor = Color.ui.blue
                                            teamOneColor = .gray
                                        }
                                    } label: {
                                        Text("Team 2")
                                            .font(.title2)
                                            .foregroundColor(.black)
                                            .frame(maxWidth: 130, maxHeight: 70)
                                            .background(teamTwoColor)
                                            .cornerRadius(20)
                                            .padding()
                                    }.shadow(color: teamTwoColor, radius: 6)
                                }
                                                                        
                            }
                        
                            Divider()
                                
                            ScrollView {
                                VStack {
                                    Text("Players:")
                                        .bold()
                                        .font(.title2)
                                    
                                    HStack {
                                        VStack {
                                            if teamOne.count == 0 {
                                                Text("Team 1 is empty.")
                                                    .italic()
                                                    .font(.caption)
                                                    .padding()
                                                    .frame(maxWidth: 350, maxHeight: 50)
                                                    .background(.black)
                                            }
                                            
                                            ForEach(teamOne) { player in
                                                HStack {
                                                    Text(player.name)
                                                        .font(.title3)
                                                        .bold()
                                                        .foregroundColor(.black)
                                                    
                                                    Button {
                                                        if let index = teamOne.firstIndex(of: player) {
                                                            teamOne.remove(at: index)
                                                        }
                                                    } label: {
                                                        Image(systemName: "trash")
                                                            .foregroundColor(.red)
                                                    }.padding()
                                                    
                                                }
                                                .frame(maxWidth: 170, maxHeight: 60)
                                                .background(Color.ui.lightGray)
                                                .cornerRadius(20)
                                                .padding()
                                                .clipped()
                                                .shadow(color: Color.ui.lightGray, radius: 6)
                                                
                                                
                                            }
                                        }
                                        
                                        Divider()
                                        
                                        VStack {
                                            if teamTwo.count == 0 {
                                                Text("Team 2 is empty.")
                                                    .italic()
                                                    .font(.caption)
                                                    .padding()
                                                    .frame(maxWidth: 350, maxHeight: 50)
                                                    .background(.black)
                                            }
                                            
                                            ForEach(teamTwo) { player in
                                                HStack {
                                                    Text(player.name)
                                                        .font(.title3)
                                                        .bold()
                                                        .foregroundColor(.black)
                                                    
                                                    Button {
                                                        if let index = teamTwo.firstIndex(of: player) {
                                                            teamTwo.remove(at: index)
                                                        }
                                                    } label: {
                                                        Image(systemName: "trash")
                                                            .foregroundColor(.red)
                                                    }.padding()
                                                    
                                                }
                                                .frame(maxWidth: 170, maxHeight: 60)
                                                .background(Color.ui.lightGray)
                                                .cornerRadius(20)
                                                .padding()
                                                .clipped()
                                                .shadow(color: Color.ui.lightGray, radius: 6)
                                                
                                                
                                            }
                                        }
                                    }
                                }
                            }
                                                            
                            if (teamOne.count + teamTwo.count) < numberOfPlayers {
                                Spacer()
                                
                                List {
                                    Section {
                                        Text("Submit player names here:")
                                            .font(.title2)
                                        
                                        TextField("Enter name...", text: $tempName)
                                            .onSubmit {
                                                if teamOneEnabled && (teamOne.count < maxTeamSize) {
                                                    teamOne.append(Player(id: tempName, name: tempName, score: 0))
                                                } else if (!teamOneEnabled) && (teamTwo.count < maxTeamSize) {
                                                    teamTwo.append(Player(id: tempName, name: tempName, score: 0))
                                                } else {
                                                    teamFull = true
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                                        teamFull = false
                                                    }
                                                }
                                                tempName = ""
                                            }.foregroundColor(.white)
                                            .modifier(ClearTextFieldButton(text: $tempName))
                                            .padding()
                                        
                                    }
                                    
                                }
                                
                                Text("That team is full.")
                                    .italic()
                                    .bold()
                                    .font(.headline)
                                    //.padding()
                                    .foregroundColor(.red)
                                    .frame(maxWidth: 350, maxHeight: 50)
                                    .background(.black)
                                    .opacity(teamFull ? 1.0 : 0)
                                    .animation(
                                        .easeIn(duration: 0.5)
                                    )
                                                                    
                            } else {
                                Spacer()
                                
                                VStack {
                                    Text("All players submitted!")
                                        .bold()
                                        .font(.title)
                                        .foregroundColor(.black)
                                        .padding(.top)
                                    
                                    VStack {
                                        
                                        NavigationLink(destination: PlayGameView(trackModel: trackModel, numberOfPlayers: numberOfPlayers, players: players, teamOne: teamOne, teamTwo: teamTwo, isTeamPlay: isTeamPlay)) {
                                            Text("Continue")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: 250, maxHeight: 70)
                                                .background(Color.ui.blue)
                                                .cornerRadius(20)
                                                .padding(.bottom)
                                        }
                                        .shadow(color: Color.ui.blue, radius: 2)
                                        .navigationBarBackButtonHidden()
                                        
                                        Button {
                                            withAnimation { teamOne.removeAll() }
                                            withAnimation { teamTwo.removeAll() }
                                        } label: {
                                            Text("Re-enter names")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: 250, maxHeight: 70)
                                                .background(.white)
                                                .cornerRadius(20)
                                                .padding()
                                        }.shadow(color: .white, radius: 2)
                                        
                                    }.padding()
                                }
                                .frame(maxWidth: 350, maxHeight: 350)
                                .background(.gray)
                                .cornerRadius(20)
                                .clipped()
                                .shadow(color: .gray, radius: 4)
                                
                                Spacer()
                            }
                        }.transition(STATE_TRANSITION)
                    } else {
                        VStack {
                            
                            ScrollView {
            
                                Text("Players:")
                                    .bold()
                                    .font(.title2)
                                              
                                Divider()
                                
                                if players.count == 0 {
                                    Text("There are no players yet...")
                                        .italic()
                                        .font(.caption)
                                        .padding()
                                        .frame(maxWidth: 350, maxHeight: 50)
                                        .background(.black)
                                }
                                
                                ForEach(players) { player in
                                    HStack {
                                        Text(player.name)
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
                                        
                                    }
                                    .frame(maxWidth: 380, maxHeight: 60)
                                    .background(.gray)
                                    .cornerRadius(20)
                                    .padding()
                                    .clipped()
                                    .shadow(color: .gray, radius: 6)

                                    
                                }
                            }
                            
                            Spacer()
                            
                            if players.count < numberOfPlayers {
                                
                                Spacer()
                                
                                List {
                                    Section {
                                        Text("Submit player names here:")
                                            .font(.title2)
                                        
                                        TextField("Enter name...", text: $tempName)
                                            .onSubmit {
                                                players.append(Player(id: tempName, name: tempName, score: 0))
                                                tempName = ""
                                            }.foregroundColor(.white)
                                            .modifier(ClearTextFieldButton(text: $tempName))
                                            .padding()
                                    }
                                }
                                                                    
                            } else {
                                Spacer()
                                
                                VStack {
                                    Text("All players submitted!")
                                        .bold()
                                        .font(.title)
                                        .foregroundColor(.black)
                                    
                                    VStack {
                                        
                                        NavigationLink(destination: PlayGameView(trackModel: trackModel, numberOfPlayers: numberOfPlayers, players: players, teamOne: teamOne, teamTwo: teamTwo, isTeamPlay: isTeamPlay)) {
                                            Text("Continue")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: 250, maxHeight: 70)
                                                .background(Color.ui.blue)
                                                .cornerRadius(20)
                                                .padding()
                                        }
                                        .shadow(color: Color.ui.blue, radius: 6)
                                        
                                        Button {
                                            withAnimation { players.removeAll() }
                                        } label: {
                                            Text("Re-enter names")
                                                .font(.title2)
                                                .foregroundColor(.black)
                                                .frame(maxWidth: 250, maxHeight: 70)
                                                .background(.white)
                                                .cornerRadius(20)
                                                .padding()
                                        }.shadow(color: .white, radius: 6)
                                        
                                    }.padding()
                                }
                                .frame(maxWidth: 350, maxHeight: 350)
                                .background(.gray)
                                .cornerRadius(20)
                                .clipped()
                                .shadow(color: .gray, radius: 6)
                                
                                Spacer()
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
                                .foregroundColor(.black)
                                .frame(maxWidth: 250, maxHeight: 70)
                                .background(Color.ui.blue)
                                .cornerRadius(20)
                                .padding()
                        }.shadow(color: Color.ui.blue, radius: 6)
                        
                        if numberOfPlayers > 3 {
                            Button {
                                isTeamPlay = true
                                maxTeamSize = numberOfPlayers / 2
                                if numberOfPlayers % 2 != 0 {
                                    maxTeamSize += 1
                                }
                                withAnimation { preGameState = .inputNames }
                            } label: {
                                Text("Team Play")
                                    .font(.title2)
                                    .foregroundColor(.black)
                                    .frame(maxWidth: 250, maxHeight: 70)
                                    .background(Color.ui.blue)
                                    .cornerRadius(20)
                                    .padding()
                            }.shadow(color: Color.ui.blue, radius: 6)
                        }
                    }.padding()
                        .transition(.asymmetric(insertion: .scale.combined(with: .opacity), removal: .scale.combined(with: .opacity)))

                }
            }
        }
}

//struct PreGameView_Previews: PreviewProvider {
//
//    static var previews: some View {
//        PreGameView()
//    }
//}
