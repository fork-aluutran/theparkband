//
//  UserTabView.swift
//  TheParkBand
//
//  Created by Jim Lambert on 2/11/25.
//

import SwiftUI
import LoremSwiftum

struct UserTabView: View {
    let SRC = "UserTabView"
    
  @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
  let user: User
  
  var body: some View {
      let _ = print("\(SRC): Called")
      
    TabView {
      ItineraryView()
        .tabItem { Label("Bulliten", systemImage: "list.clipboard").opacity(0.6) }
      ScheduleView()
        .tabItem { Label("Schedule", systemImage: "calendar").opacity(0.6) }
      UsersLocationView()
        .tabItem { Label("Locations", systemImage: "location.fill").opacity(0.6) }
      MessageView()
        .tabItem { Label("Messages", systemImage: "bubble.left.and.bubble.right.fill").opacity(0.6) }
      SettingsView(user: user).environmentObject(authenticationViewModel)
        .tabItem { Label("Settings", systemImage: "gear").opacity(0.6) }
    }
  }
}

// PREVIEW USER TAB VIEW
struct UserTabView_Previews: PreviewProvider {
  static var previews: some View {
    UserTabView(user: User(
      uid: "1234",
      displayName: Lorem.firstName,
      email: Lorem.emailAddress,
      phoneNumber: "334-372-7120",
      isAdmin: false,
      createdOn: Date())
    ).environmentObject(AuthenticationViewModel())
  }
}


