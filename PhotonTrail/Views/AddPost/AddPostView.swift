//
//  AddPostView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/12/16.
//

import SwiftUI
import PhotosUI


struct AddPostView: View {
    @EnvironmentObject var modelData: ModelData
    @Binding var showAddPost: Bool
    @ObservedObject var addPostViewModel: AddPostViewModel

    @State private var title: String = ""
    @State private var content: String = ""
    @State private var camera: String = ""
    @State private var lens: String = ""
    @State private var selectedImages: [UIImage] = []
    @State private var isImagePickerPresented: Bool = false

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading) {
                        Text("标题")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("", text: $title)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }

                    VStack(alignment: .leading) {
                        Text("描述")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextEditor(text: $content)
                            .scrollContentBackground(.hidden)
                            .frame(height: 120)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }

                    // 图片展示与选择
                    VStack(alignment: .leading) {
                        Text("照片")
                            .font(.headline)
                            .foregroundColor(.gray)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(selectedImages, id: \.self) { image in
                                    Image(uiImage: image)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(10)
                                        .overlay(
                                            Button(action: {
                                                if let index = selectedImages.firstIndex(of: image) {
                                                    selectedImages.remove(at: index)
                                                }
                                            }) {
                                                Image(systemName: "xmark.circle.fill")
                                                    .foregroundColor(.white)
                                                    .background(Color.black.opacity(0.7))
                                                    .clipShape(Circle())
                                            }
                                            .offset(x: 35, y: -35)
                                        )
                                }
                                Button(action: {
                                    isImagePickerPresented = true
                                }) {
                                    VStack {
                                        Image(systemName: "plus")
                                            .font(.largeTitle)
                                            .foregroundColor(.button)
                                            .padding()
                                        Text("添加照片")
                                            .font(.footnote)
                                            .foregroundColor(.button)
                                    }
                                    .frame(width: 100, height: 100)
                                    .background(Color(.secondarySystemBackground))
                                    .cornerRadius(10)
                                }
                            }
                        }
                    }
                    
                    HStack(alignment: .center, spacing: 20) {
                        Text("相机")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("", text: $camera)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }
                        
                    HStack(alignment: .center, spacing: 20) {
                        Text("镜头")
                            .font(.headline)
                            .foregroundColor(.gray)
                        TextField("", text: $lens)
                            .padding()
                            .background(Color(.secondarySystemBackground))
                            .cornerRadius(10)
                    }

                    VStack {
                        if addPostViewModel.addPostLoading {
                            GeometryReader { geometry in
                                VStack {
                                    ProgressView("发布中...")
                                        .frame(width: geometry.size.width, alignment: .center)
                                        .padding(.vertical, 10)
                                }
                            }
                        } else {
                            Button(action: {
                                addPostViewModel.addPost(title: title, content: content, images: selectedImages, camera: camera, lens: lens) { success in
                                    if success {
                                        showAddPost = false
                                    }
                                }
                            }) {
                                Text("发布")
                                    .frame(maxWidth: 200)
                                    .padding()
                                    .background(selectedImages.isEmpty || title.isEmpty || content.isEmpty ? Color.gray : Color.button)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(selectedImages.isEmpty || title.isEmpty || content.isEmpty)
                        }
                        
                        Text(addPostViewModel.msg)
                    }
                    .padding(.horizontal, 100)
                }
                .padding()
            }
            .navigationTitle("发布照片")
            .sheet(isPresented: $isImagePickerPresented) {
                MultipleImagePicker(selectedImages: $selectedImages)
            }
        }
        .onAppear(perform: {
            addPostViewModel.msg = ""
            addPostViewModel.progress = 0.0
            addPostViewModel.addPostLoading = false
        })
    }
}

#Preview {
    AddPostView(showAddPost: .constant(true), addPostViewModel: AddPostViewModel())
}
