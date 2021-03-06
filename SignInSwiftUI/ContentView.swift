//
//  ContentView.swift
//  SignInSwiftUI
//
//  Created by Gary on 2/1/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI
import Combine


fileprivate final class UserInfo : ObservableObject {
    @Published var name = ""
    @Published var password = ""
    @Published var verifyPassword = ""
    @Published var infoValid = false
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    private func nameIsValid() -> Bool {
        return name.count > 5
    }

    private func passwordIsValid() -> Bool {
        return password.count > 5
    }

    private func passwordsAreTheSame() -> Bool {
        return password == verifyPassword
    }

    private func infoIsValid() -> Bool {
        return nameIsValid() && passwordIsValid() && passwordsAreTheSame()
    }

    private var validatedUserInfo: AnyPublisher<Bool, Never> {
        // do validation whenever any of the three fields change
        return Publishers.CombineLatest3($name, $password, $verifyPassword)
                .receive(on: RunLoop.main)
                .map { _, _, _ in
                    guard self.nameIsValid() else {
                        return false
                    }
                    guard self.passwordIsValid() else {
                        return false
                    }
                    guard self.passwordsAreTheSame() else {
                        return false
                    }
                    
                    return true
                }.eraseToAnyPublisher()
        }
    
    init() {
        validatedUserInfo
            .map { $0 }
            .receive(on: RunLoop.main)
            .assign(to: \.infoValid, on: self)
            .store(in: &cancellableSet)     // save a reference so we don't get garbage collected
    }
}

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
                            Text("Signup")
                        }.disabled(!userInfo.infoValid)
                        Spacer()
                    }
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
