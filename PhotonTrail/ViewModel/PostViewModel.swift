//
//  PhotoViewModel.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

class PostViewModel: ObservableObject {
    @Published var photoList = [Post]()
}
