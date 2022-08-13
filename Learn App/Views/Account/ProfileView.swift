//
//  ProfileView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 08.06.2022.
//

import SwiftUI
import FirebaseAuth

struct ProfileView: View {
    
    @EnvironmentObject var model: ContentModel
    
    
    var body: some View {
        VStack {
            Text("Hello, " + UserService.shared.user.name)
                .font(.title)
            Button("Sign Out") {
                if model.loggedIn {
                    try? Auth.auth().signOut()
                    model.checkLogin()
                }
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ContentModel())
    }
}
