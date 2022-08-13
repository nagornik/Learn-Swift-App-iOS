//
//  LaunchView.swift
//  Learn App
//
//  Created by Anton Nagornyi on 08.06.2022.
//

import SwiftUI

struct LaunchView: View {
    
    @EnvironmentObject var model: ContentModel
    
    var body: some View {
        if model.loggedIn == false {
            LoginView()
                .onAppear {
                    model.checkLogin()
                }
        } else {
            TabView {
                if model.modules.count == 0 {
                    ProgressView()
                } else {
                    HomeView()
                        .tabItem {
                            VStack {
                                Image(systemName: "book")
                                Text("Learn")
                            }
                        }
                    ProfileView()
                        .tabItem {
                            VStack {
                                Image(systemName: "person")
                                Text("Account")
                            }
                        }
                }
            }

            
            
            
            
            .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { output in
                model.saveData(writeToDatabase: true)
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
            .environmentObject(ContentModel())
    }
}
