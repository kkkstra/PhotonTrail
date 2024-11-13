//
//  ContentView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack{
            TabView(selection: $selection, content: {
                CardHome(weatherVM: weatherVM, factsVM: factsVM, photoVM: photoVM)
                    .tag(Tab.home)
                NoteView(viewModel: noteVM)
                    .tag(Tab.note)
                EmptyView()
                    .tag(Tab.add)
                CommunityView(shopVM: shopVM)
                    .tag(Tab.community)
                MineView()
                    .tag(Tab.mine)
            })
        }
    }
}

#Preview {
    ContentView()
}
