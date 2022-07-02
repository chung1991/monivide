//
//  UserDataAccess.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation

class UserDataAccess {
    static let shared = UserDataAccess()

    func getCurrentUser() -> UserEntity? {
        return UserEntity(username: "chung1991")
    }
    
    func getSelectedUser() -> UserEntity? {
        return UserEntity(username: "hanhnv")
    }
}
