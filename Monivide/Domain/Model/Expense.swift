//
//  Expense.swift
//  Monivide
//
//  Created by Chung Nguyen on 7/6/22.
//

import Foundation

class Expense {
    let id: UUID
    let title: String
    let amount: Double
    var currentAmountDifferent: Double
    let createdUser: String
    let users: [String]
    let rate: [Double]
    let date: Date
    
    init(id: UUID,
         title: String,
         amount: Double,
         createdUser: String,
         users: [String],
         rate: [Double],
         date: Date) {
        
        self.id = id
        self.title = title
        self.amount = amount
        self.currentAmountDifferent = amount
        self.createdUser = createdUser
        self.users = users
        self.rate = rate
        self.date = date
    }
    
    lazy var paid: String = {
        guard let index = rate.enumerated().first(where: { $0.1 == 1.0 })?.0 else {
            fatalError()
        }
        return users[index]
    }()
    
    func getAmountDifferent(_ username: String) -> Double {
        if self.paid == username {
            self.currentAmountDifferent = amount
            return amount
        }
        self.currentAmountDifferent = -amount
        return -amount
    }
}
