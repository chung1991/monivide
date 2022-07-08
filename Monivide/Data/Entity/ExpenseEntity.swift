//
//  TransactionEntity.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/6/22.
//

import Foundation

struct ExpenseEntity {
    let id: UUID
    let title: String
    let amount: Double
    let createdUser: String
    let users: [String]
    let rate: [Double]
    let date: Date
}
