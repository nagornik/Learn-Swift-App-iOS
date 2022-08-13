//
//  UserService.swift
//  Learn App
//
//  Created by Anton Nagornyi on 08.06.2022.
//

import Foundation

class UserService {
    
    @Published var user = User()
    
    static var shared = UserService()
    
    private init() {
        
    }
}
