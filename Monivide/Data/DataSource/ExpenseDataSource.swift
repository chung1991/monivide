//
//  TransactionDataSource.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/6/22.
//

import Foundation

protocol ExpenseDataSource {
    func addExpense(_ expenseEntity: ExpenseEntity)
    func getExpensesByUsername(_ username: String) -> [ExpenseEntity]
}

struct ExpenseDataSourceImpl: ExpenseDataSource {
    let database = Database.shared
    func addExpense(_ expenseEntity: ExpenseEntity) {
        database.expenses.append(expenseEntity)
    }
    func getExpensesByUsername(_ username: String) -> [ExpenseEntity] {
        return database.expenses.filter { $0.users.contains(username) }.sorted { $0.date > $1.date }
    }
}
