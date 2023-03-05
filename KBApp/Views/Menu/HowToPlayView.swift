//
//  HowToPlayView.swift
//  KBApp
//
//  Created by Sam Richard on 1/19/23.
//

import SwiftUI


struct HowToPlayView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            Color.ui.newBlue.ignoresSafeArea()
            
            VStack {
                Text("Welcome to\nKazoo Bugaloo!")
                    .font(.title)
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .multilineTextAlignment(.center)
                
                Divider()
                    
                Spacer()
                
                VStack(alignment: .leading) {
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "music.note.list")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            
                            Text("Pick a playlist")
                                .font(.title3)
                                .bold()
                                .italic()
                                .foregroundColor(.white)
                                .padding(.leading)
                        }
                        
                        Text("The playlist you choose will be your \"deck\" of songs to choose from when you play!")
                            .frame(maxWidth: 300, alignment: .leading)
                            .font(.subheadline)
                            .padding(.top, 6)
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "square.and.pencil")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            
                            Text("Set up your game")
                                .font(.title3)
                                .italic()
                                .bold()
                                .foregroundColor(.white)
                                .padding(.leading)
                        }
                        
                        Text("Input your player info, select your mode, and input everyone's names!")
                            .frame(maxWidth: 300, alignment: .leading)
                            .font(.subheadline)
                            .padding(.top, 6)
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "play.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            
                            Text("Get ready to perform")
                                .font(.title3)
                                .italic()
                                .bold()
                                .foregroundColor(.white)
                                .padding(.leading)
                        }
                        
                        Text("When it's your turn, you will have 40 seconds and 3 passes to try to hum the song to your team. Kazoo optional.")
                            .frame(maxWidth: 300, alignment: .leading)
                            .font(.subheadline)
                            .padding(.top, 6)
                    }.padding(.bottom)
                    
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "exclamationmark.circle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
                            
                            Text("Kazoo Bugaloo")
                                .font(.title3)
                                .italic()
                                .bold()
                                .foregroundColor(.white)
                                .padding(.leading)
                        }
                        
                        Text("If your team(or another player in Free-For-All) guesses your song, you earn a point! First player/team to 5 points wins!")
                            .frame(maxWidth: 300, alignment: .leading)
                            .font(.subheadline)
                            .padding(.top, 6)
                    }.padding(.bottom)
                }
                
                Spacer()
                
                Button {
                    dismiss()
                } label: {
                    Text("Close")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.black)
                        .frame(maxWidth: 250, maxHeight: 70)
                        .background(.white)
                        .cornerRadius(20)
                        .padding()
                        .shadow(color: .white, radius: 4)
                }
                    
            }
        }
    }
}

struct HowToPlayView_Previews: PreviewProvider {
    static var previews: some View {
        HowToPlayView()
    }
}
