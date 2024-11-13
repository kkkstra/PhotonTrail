//
//  ProfileView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var phone: String = ""
    @State private var authCode: String = ""
    @Binding var showProfile: Bool
    
    var body: some View {
        Text("Hello, world")
    }
}

#Preview {
    ProfileView(showProfile: .constant(true))
        .environmentObject(ModelData())
}
