//
//  ContentView.swift
//  SignInSwiftUI
//
//  Created by Gary on 2/1/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI
import Combine


struct SignupView: View {
    @ObservedObject private var userInfo = UserInfo()

    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("User name", text: $userInfo.name)
                    SecureField("Password", text: $userInfo.password)
                    SecureField("Verify password", text: $userInfo.verifyPassword)
                }
                Section {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.submit()
                            }) {
                            Text("Sign up")
                        }.disabled(!userInfo.infoValid)
                        Spacer()
                    }
                }
                HStack {
                    Spacer()
                    Text(userInfo.errorMessage)
                        .foregroundColor(.red)
                    Spacer()
                }
            }
            .padding(.top, 20)
            .navigationBarTitle("User Signup")
            // transitions aren't working since Xcode 11.2. Hopefully fixed someday
            //.animation(.easeInOut(duration: 1.0))
            //.transition(.opacity)
        }
        .navigationBarBackButtonHidden(true)
    }

    private func submit() {
        print("User info submitted")
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
