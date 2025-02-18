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
      
      /*
      print("\(SRC): firebaseApp.options = \(toStr())")
      
      guard let clientID = firebaseApp.options.clientID else {
          print("\(SRC): ERROR: Missing clientID.")
          return
      }
      */
      
      let clientID = "911972533915-ej0h8motto4mak56gn6vrpi4fd5vo1g8.apps.googleusercontent.com"
      print("\(SRC): CLIENT ID: \(clientID)")
      let config = GIDConfiguration(clientID: clientID)
      print("\(SRC): CONFIG: \(config)")
      GIDSignIn.sharedInstance.configuration = config
      
      // START SIGN IN FLOW
      guard let rootViewController =  UIApplication.shared.rootViewController() else { throw GIDSignInError(.unknown) }
      let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController, hint: nil, additionalScopes: scopes)
      print("\(SRC): GOOGLE SIGN IN RESULT: \(toStr(result))")
      
      // CREDENTIAL CREATED
      guard let idToken = result.user.idToken else { throw GIDSignInError(.unknown) }
      let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: result.user.accessToken.tokenString)
      
      // SIGN INTO FIREBASE WITH CREDIATIAL
      print("\(SRC): Awaiting signIn(): credential = \(credential)")
      Auth.auth().signIn(with: credential) {result, error in
          let SRC = self.SRC + ".signIn"
          print("\(SRC): result = \(String(describing: result))|error = \(String(describing: error)))")
          // At this point, our user is signed in
      }
      
      print("\(SRC): Done")
  } // signIn()
  
  // MARK: SIGN OUT OF FIREBASE & GOOGLE
  func signOut() throws {
    GIDSignIn.sharedInstance.signOut()
    try Auth.auth().signOut()
  }
    
    private func toStr(_ result: GIDSignInResult) -> String {
        let user = result.user
        let idToken = user.idToken!.tokenString
        let accessToken = user.accessToken.tokenString
        return "<User: idToken = \(idToken)|accessToken = \(accessToken)|>"
    }
} // AuthenticationViewModel()


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
