//
//  ProfileView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI
import UIKit
import NukeUI

struct ProfileView: View {
    @EnvironmentObject var modelData: ModelData
    
    @State private var name: String = ""
    @State private var description: String = ""
    @State private var selectedImage: UIImage?
    @State private var isImagePickerPresented = false
    @Binding var showProfile: Bool
    
    @StateObject var profileViewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    // 头像选择区域
                    Section {
                        HStack {
                            Spacer()
                            ZStack {
                                if let selectedImage = selectedImage {
                                    Image(uiImage: selectedImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                } else {
                                    LazyImage(url: URL(string: modelData.user?.avatar ?? "")) { state in
                                        if let image = state.image {
                                            image
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        } else {
                                            Image("defaultAvatar")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 100, height: 100)
                                                .clipShape(Circle())
                                                .overlay(Circle().stroke(Color.white, lineWidth: 3))
                                        }
                                    }
                                }
                                
                                // 头像选择按钮
                                Button(action: {
                                    isImagePickerPresented = true
                                }) {
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white)
                                        .background(Circle().fill(Color.blue).frame(width: 36, height: 36))
                                        .offset(x: 40, y: 40)
                                }
                            }
                            Spacer()
                        }
                        HStack {
                            Text("昵称")
                                .frame(width: 80, alignment: .leading) // 固定标签宽度
                            TextField("", text: $name)
                        }
                        
                        HStack {
                            Text("邮箱")
                                .frame(width: 80, alignment: .leading)
                            Text(modelData.user?.email ?? "")
                                .foregroundColor(.gray)
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("个人简介")
                                    .frame(width: 80, alignment: .center)
                                Text("(200字以内)")
                                    .frame(width: 80, alignment: .center)
                                    .font(.caption2)
                            }
                            TextEditor(text: $description)
                                .frame(height: 200)
                        }
                    }
                }
                .navigationBarTitle("个人资料", displayMode: .inline)
                .navigationBarItems(trailing: Button("关闭") {
                    showProfile = false
                })
                .sheet(isPresented: $isImagePickerPresented) {
                    ImagePicker(selectedImage: $selectedImage)
                }
                .onAppear {
                    loadUserData()
                }
                
                VStack(spacing: 12) {
                    Text(profileViewModel.msg)
                    
                    Button(action: saveProfile) {
                        Text("保存")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.button)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                    .padding(.horizontal, 100)
                    
                    Button(action: logout) {
                        Text("退出登录")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.button2)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .listRowBackground(Color.clear)
                    .padding(.horizontal, 100)
                }
                .padding(.top, 20)
            }
            .onAppear(perform: {
                profileViewModel.initData(modelData: modelData)
            })
        }
    }

    // 加载用户数据的方法
    private func loadUserData() {
        name = modelData.user?.name ?? ""
        description = modelData.user?.description ?? ""
    }

    // 保存用户数据的方法
    private func saveProfile() {
        // save profile
        profileViewModel.updateProfile(name: name, description: description, image: selectedImage)
        loadUserData()
        showProfile.toggle()
    }
    
    private func logout() {
        GlobalParams.logout()
        modelData.user = nil
        UserDefaults.standard.set(nil, forKey: DataKeys.LOGIN_RESULT)
        showProfile.toggle()
    }
}


#Preview {
    ProfileView(showProfile: .constant(true))
        .environmentObject(ModelData())
}
