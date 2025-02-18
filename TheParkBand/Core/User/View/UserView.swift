//
//  UserView.swift
//  TheParkBand
//
//  Created by Jim Lambert on 2/5/25.
//

import SwiftUI
import FirebaseAuth

struct UserView: View {
    let SRC = "UserView"
    
  @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
//    @StateObject var userViewModel = UserViewModel()
  
  var body: some View {
    let _ = print("\(SRC): Called")
      
    ZStack {
      if let user = authenticationViewModel.user {
        UserTabView(user: user)
      } else {
        ProgressView()
      }
    }
  //    .onAppear {
  //      if let authenticatedUser = authenticationViewModel.user {
  //        userViewModel.load(user: authenticatedUser)
  //      }
  //    }
  }
}

// PREVIEW AUTHENTICAITON VIEW
struct UserView_Previews: PreviewProvider {
  static var previews: some View {
    UserView().environmentObject(AuthenticationViewModel())
  }
}
