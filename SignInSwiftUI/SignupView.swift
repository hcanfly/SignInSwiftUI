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
    @Published var errorMessage = ""
    
    private var cancellableSet: Set<AnyCancellable> = []
    
    
    private func nameIsValid() -> Bool {
        var isValid = true
        self.errorMessage = ""

        if self.name.count < 6 {
            isValid = false
            if self.name.count > 2 {
                self.errorMessage = "User name must have at least six characters"
            }
        }
        return isValid
    }

    private func passwordIsValid() -> Bool {
        var isValid = true
        self.errorMessage = ""

        if self.password.count < 6 {
            isValid = false
            if self.password.count > 2 {
                self.errorMessage = "Password must have at least six characters"
            }
        }
        return isValid
    }

    private func passwordsAreTheSame() -> Bool {
        if password == verifyPassword {
            return true
        } else {
            if self.verifyPassword.count > 5 {
                self.errorMessage = "Passwords must be the same"
            }
            return false
        }
    }

    private func infoIsValid() -> Bool {
        return nameIsValid() && passwordIsValid() && passwordsAreTheSame()
    }

    private var validatedUserInfo: AnyPublisher<Bool, Never> {
        self.errorMessage = ""
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
            .store(in: &cancellableSet)     // save a reference so we don't get garbage collected until we're done
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
