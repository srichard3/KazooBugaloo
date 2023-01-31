//
//  AlbumView.swift
//  KBApp
//
//  Created by Sam Richard on 1/6/23.
//

import SwiftUI

//struct AlbumView: View {
//    var model: FeaturedPlaylistCellModel
//
//    var body: some View {
//        VStack {
//            Text(model.name)
//                .onAppear {
//                    fetchData()
//                }
//        }.navigationTitle(model.name)
//    }
//
//    private func fetchData() {
//        APICaller.shared.getAlbumDetails(for: model.id) { result in
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let model):
//                    break
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//        }
//    }
//}
//
//struct AlbumView_Previews: PreviewProvider {
//    static var previews: some View {
//        AlbumView()
//    }
//}
