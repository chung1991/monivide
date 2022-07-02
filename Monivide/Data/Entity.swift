//
//  Entity.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation

struct UserEntity: Equatable {
    let username: String
}

struct TransactionEntity {
    let id: UUID
    let title: String
    let amount: Double
    let paid: UserEntity
    let owned: UserEntity
    let date: Date
}
