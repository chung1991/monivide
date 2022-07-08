//
//  MoneyDataAccess.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation

protocol MoneyDataAccess {
    var userDataSource: UserDataSource { get set }
    var expenseDataSource: ExpenseDataSource { get set }
    func getExpensesByUsername(_ username: String) -> [ExpenseEntity]
}

struct MoneyDataAccessImpl: MoneyDataAccess {
    var userDataSource: UserDataSource
    var expenseDataSource: ExpenseDataSource
    func getExpensesByUsername(_ username: String) -> [ExpenseEntity] {
        return expenseDataSource.getExpensesByUsername(username)
    }
}
