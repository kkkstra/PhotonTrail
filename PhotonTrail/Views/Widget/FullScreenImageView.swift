//
//  FullScreenImageView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/12/16.
//

import SwiftUI
import NukeUI

struct FullScreenImageView: View {
    @Binding var imageURL: String
    let defaultImage: String
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            LazyImage(url: URL(string: imageURL)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .scaledToFit()
                } else {
                    Image(defaultImage)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                }
            }
 
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                    }
                    .padding()
                }
                Spacer()
            }
        }
    }
}
