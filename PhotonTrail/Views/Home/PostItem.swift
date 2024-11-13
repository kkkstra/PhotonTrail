//
//  PhotoItem.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import NukeUI

struct PostItem: View {
    var post: Post
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                LazyImage(url: URL(string: post.avatar)) { image in
                    image.image?.resizable()
                        .scaledToFill()
                }
                .frame(width: 48, height: 48)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                Text(post.name)
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()
                
                Text(post.getPublishedTime())
                    .font(.subheadline)
                //                Image(systemName: "ellipsis")
            }
            .padding(.trailing)
            .padding(.leading)
            .padding(.top)
        }
        
        PhotoPageView(pages: post.images.map({
            LazyImage(url: URL(string: $0.imageUrl)){phase in
                phase.image?.resizable()
                    .scaledToFit()
                    .transition(.opacity.animation(.smooth))
            }
        }))
        .frame(maxWidth: .infinity)
        .aspectRatio(CGFloat(post.images[0].width) / CGFloat( post.images[0].height + 1), contentMode: .fill)
        
        VStack(alignment: .leading){
            if(!post.title.isEmpty){
                Text(post.title)
                    .font(.title3)
                    .padding(.bottom, 4)
            }
            if(!post.content.isEmpty){
                Text(post.content)
                    .font(.body)
                    .padding(.bottom, 4)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 6)
        .padding(.leading)
        .padding(.trailing)
        .padding(.bottom)
    }
}

#Preview {
    PostItem(post: Post(id:1))
}
