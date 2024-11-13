//
//  PhotosView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import NukeUI

struct PhotosView: View {
    var body: some View {
        VStack {
            let columns = [
                GridItem(.flexible(), spacing: 1),
                GridItem(.flexible(), spacing: 1),
                GridItem(.flexible(), spacing: 1),
                GridItem(.flexible(), spacing: 1)
            ]
            
            LazyVGrid(columns: columns, spacing: 1) {
                ForEach(["https://icemono.oss-cn-hangzhou.aliyuncs.com/images/denis-istomin-kaspa2.jpg", "0", "1", "2", "3"], id: \.self) { photoURL in
                    LazyImage(url: URL(string: photoURL)) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipped()
                        } else {
                            Color.gray // 占位颜色或图片
                                .frame(width: 100, height: 100)
                        }
                    }
                    .frame(width: 100, height: 100)
                }
            }
        }
    }
}

#Preview {
    PhotosView()
}
