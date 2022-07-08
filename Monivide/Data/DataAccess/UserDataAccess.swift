//
//  UserDataAccess.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/7/22.
//

import Foundation

protocol UserDataAccess {
    var userDataSource: UserDataSource { get set }
    func getUserByUsername(_ username: String) -> UserEntity?
}

struct UserDataAccessImpl: UserDataAccess {
    var userDataSource: UserDataSource
    
    func getUserByUsername(_ username: String) -> UserEntity? {
        return userDataSource.getUserByUsername(username)
    }
}
