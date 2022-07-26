//
//  UserDataAccess.swift
//  Monivide
//
//  Created by Chung Nguyen on 7/1/22.
//

import Foundation

protocol UserDataSource {
    func getUserByUsername(_ username: String) -> UserEntity?
}

struct UserDataSourceImpl: UserDataSource {
    let database = Database.shared
    func getUserByUsername(_ username: String) -> UserEntity? {
        return database.users[username]
    }
}
