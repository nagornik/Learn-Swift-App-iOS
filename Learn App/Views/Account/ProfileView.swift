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
        NavigationView {
            VStack(alignment: .leading) {
                HStack {
                    Text("Lessons completed: \(UserService.shared.user.completedLessons.count)")
//                        .font(.title)
                }
                
                ForEach(UserService.shared.user.completedLessons, id:\.self) { lesson in  
                    Text(lesson)
                }
                
                Button("Sign Out") {
                    if model.loggedIn {
                        try? Auth.auth().signOut()
                        model.checkLogin()
                    }
                }
            }
            .navigationTitle("Hello, " + UserService.shared.user.name)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(ContentModel())
    }
}
