//
//  LandingView.swift
//  SignInSwiftUI
//
//  Created by Gary on 2/5/20.
//  Copyright © 2020 Gary Hanson. All rights reserved.
//

import SwiftUI


struct LandingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Image("Clouds")
                Text("We have a great product. Please be a dear and sign up.")
                    .font(.title)
                    .foregroundColor(.white)
                    .frame(width: 360)
                    .offset(y: -140)
                NavigationLink(destination: SignupView()) {
                    Text("Sign up")
                    .frame(width: 160, height: 40)
                    .font(.title)
                    .foregroundColor(.white)
                    .background(Capsule().stroke(lineWidth: 2).fill(Color.white))
                }
                .offset(y: -40)
            }
        }
    }
}

struct LandingView_Previews: PreviewProvider {
    static var previews: some View {
        LandingView()
    }
}
