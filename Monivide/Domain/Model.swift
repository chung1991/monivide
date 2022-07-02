//
//  Model.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation

struct User: Equatable {
    let username: String
}

struct Transaction {
    let id: UUID
    let title: String
    let amount: Double
    let paid: String
    let owned: String
    let date: Date
}
