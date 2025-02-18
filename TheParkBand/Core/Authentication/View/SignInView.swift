//
//  SignInView.swift
//  TheParkBand
//
//  Created by Jim Lambert on 2/5/25.
//


import SwiftUI

struct SignInView: View {
    let SRC = "SignInView"
    
  @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
  var body: some View {
      let _ = print("\(SRC): Called")
      
    VStack {
      Image("AppLogo")
        .resizable()
        .scaledToFit()
        .padding()
      Button {
        Task {
          try await authenticationViewModel.signIn(scopes: ["https://www.googleapis.com/auth/calendar.events.readonly"])
        }
      } label: {
        Image("GoogleIcon")
          .resizable()
          .scaledToFit()
          .frame(maxWidth: 30, maxHeight: 30)
        Text("Sign In with Google")
          .fontWeight(.semibold)
          .frame(maxWidth: .infinity)
      }
      .buttonStyle(.bordered)
      .buttonBorderShape(.roundedRectangle)
      .tint(.secondary)
      .padding()
    }
  }
}

#Preview {
  SignInView()
}
