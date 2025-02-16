//
//  AuthenticationViewModel.swift
//  TheParkBand
//
//  Created by Jim Lambert on 2/5/25.
//

import FirebaseCore
import FirebaseAuth
import GoogleSignIn

@MainActor
final class AuthenticationViewModel: ObservableObject {
    let SRC = "AuthenticationViewModel"
    
  @Published var state: AuthenticationState = .signedOut
  @Published var user: User?
  
  var handle: AuthStateDidChangeListenerHandle?
  
  init() {
    handle = Auth.auth().addStateDidChangeListener { _, user in
      if let user {
        self.user = User(authenticatedUser: user)
        print(user)
        self.state = .signedIn
      } else {
        self.state = .signedOut
      }
      print(self.state)
    }
  }
  
  // MARK: SIGN INTO FIREBASE
  func signIn(scopes: [String]) async throws {
      let SRC = self.SRC + ".signIn"
      print("\(SRC): Called")
      
      // CREATE CONFIGURATION OBJECT
      guard let firebaseApp = FirebaseApp.app() else {
          print("\(SRC): ERROR: FirebaseApp is nil.")
          return
      }
      
      guard let clientID = firebaseApp.options.clientID else {
          print("\(SRC): ERROR: Missing clientID.")
          return
      }
      
      print("\(SRC): CLIENT ID: \(clientID)")
      let config = GIDConfiguration(clientID: clientID)
      print("\(SRC): CONFIG: \(config)")
      GIDSignIn.sharedInstance.configuration = config
      
      // START SIGN IN FLOW
      guard let rootViewController =  UIApplication.shared.rootViewController() else { throw GIDSignInError(.unknown) }
      let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, hint: nil, additionalScopes: scopes)
      print("\(SRC): GOOGLE SIGN IN RESULT: \(result)")
      
      // CREDENTIAL CREATED
      guard let idToken = result.user.idToken else { throw GIDSignInError(.unknown) }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: result.user.accessToken.tokenString)
      
      // SIGN INTO FIREBASE WITH CREDIATIAL
      try await Auth.auth().signIn(with: credential)
  } // signIn()
  
  // MARK: SIGN OUT OF FIREBASE & GOOGLE
  func signOut() throws {
    GIDSignIn.sharedInstance.signOut()
    try Auth.auth().signOut()
  }
}


// MARK: RESTORE GOOGLE AUTHENTICATION
extension AuthenticationViewModel {
  func restoreSession() {
    GIDSignIn.sharedInstance.restorePreviousSignIn()
    GIDSignIn.sharedInstance.currentUser?.refreshTokensIfNeeded { user, error in }
  }
}

// MARK: AUTHENTICATION STATE
extension AuthenticationViewModel {
  enum AuthenticationState {
    case signedIn
    case signedOut
  }
}
