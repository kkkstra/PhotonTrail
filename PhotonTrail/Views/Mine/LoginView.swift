//
//  LoginView.swift
//  PhotonTrail
//
//  Created by Patrick Lai on 2024/11/13.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject var loginViewModel = LoginViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    
    var body: some View {
        ZStack{
            Color.gray.ignoresSafeArea(edges: .top)
            
            VStack() {
                Text("光迹")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                
                Text("Photon Trail")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                
                HStack{
                    Text(loginViewModel.errorMsg)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(){
                    TextField("电子邮箱", text: $email)
                        .keyboardType(.emailAddress)
                    
                }
                .padding(12)
                .background(.inputBg)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.horizontal)
                
                Spacer().frame(height: 16)
                
                HStack(spacing: 8){
                    TextField("密码", text: $password)
                        .keyboardType(.asciiCapable)
                }
                .padding(12)
                .background(.inputBg)
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.horizontal)
                
                Spacer().frame(height: 24)
                
                
                HStack {
                    if (loginViewModel.loginLoading) {
                        ProgressView("登录中...")
                            .padding()
                    } else {
                        Button("登录", action: {
                            loginViewModel.login(mail: self.email, password: self.password)
                        })
                        .frame(width: 64)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(.button)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                    
                    Spacer().frame(width: 24)
                    
                    if (loginViewModel.registerLoading) {
                        ProgressView("注册中...")
                            .padding()
                    } else {
                        Button("注册", action: {
                            loginViewModel.register(mail: self.email, password: self.password)
                        })
                        .frame(width: 64)
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                        .padding(.horizontal)
                        .padding(.vertical, 10)
                        .background(.button2)
                        .clipShape(.rect(cornerRadius: 10))
                    }
                }
            }
            .padding()
            .background(.loginBg)
            .fontDesign(.rounded)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding(32)
            .dismissKeyboardOnScroll()
        }
        .onAppear(perform: {
            loginViewModel.initData(modelData: modelData)
        })
    }
}

#Preview {
    LoginView(loginViewModel: LoginViewModel())
        .environmentObject(ModelData())
}
