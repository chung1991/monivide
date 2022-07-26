//
//  UserService.swift
//  Monivide
//
//  Created by Chung Nguyen on 7/6/22.
//

import Foundation

protocol UserService {
    var userDataAccess: UserDataAccess { get set }
    func getUserByUsername(_ username: String) -> User?
}

struct UserServiceImpl: UserService {
    var userDataAccess: UserDataAccess
    func getUserByUsername(_ username: String) -> User? {
        guard let entity = userDataAccess.getUserByUsername(username) else {
            return nil
        }
        return User(username: entity.username)
    }
}
