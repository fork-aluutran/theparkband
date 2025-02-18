//
//  AuthenticationView.swift
//  TheParkBand
//
//  Created by Jim Lambert on 2/5/25.
//

import SwiftUI


struct AuthenticationView: View {
    let SRC = "AuthenticationView"
    
  @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
  
  var body: some View {
      let _ = print("\(SRC): Called")
      
    switch authenticationViewModel.state {
      case .signedIn:
        UserView().environmentObject(authenticationViewModel)
      case .signedOut:
        SignInView()
        
    }
  }
}

// PREVIEW AUTHENTICAITON VIEW
struct AuthenticationView_Previews: PreviewProvider {
  static var previews: some View {
    AuthenticationView().environmentObject(AuthenticationViewModel())
  }
}
