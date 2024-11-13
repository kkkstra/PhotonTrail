//
//  ModelData.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import Foundation

class ModelData: ObservableObject {
    @Published var user: User?
    
    init() {
        self.user = User(
            id: 1,
            name: "Patrick Lai",
            email: "yuxin.lai@hust.edu.cn",
            avatar: "https://kkkstra.cn/assets/img/logo4.jpg",
            description: "当你什么都不在乎了，你的人生才真正的开始。无能为力 ，叫顺其自然。心无所谓 ，才叫随遇而安。在别人眼里你很温柔，其实 ，哪有什么天生，温柔只是学会了控制情绪而已。")
    }
    
    func saveLoginData(res: LoginResult){
        self.user = res.user
    }
}
