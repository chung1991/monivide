//
//  MoneyService.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation
import OrderedCollections

protocol MoneyService {
    var dateService: DateUtils { get set }
    var moneyDataAccess: MoneyDataAccess { get set }
    func getExpenses(by username: String) -> OrderedDictionary<Date, [Expense]>
}

struct MoneyServiceImpl: MoneyService {
    var dateService: DateUtils
    var moneyDataAccess: MoneyDataAccess
    
    /// Return ordered dictionary:
    /// - key: order by month of transaction ASC
    /// - values: order by transaction date ASC
    func getExpenses(by username: String) -> OrderedDictionary<Date, [Expense]> {
        let entities = moneyDataAccess.getExpensesByUsername(username)
        var hash: OrderedDictionary<Date, [Expense]> = [:]
        let monthFormat = "MMMM yyyy"
        for entity in entities {
            let monthInString = dateService.getDateString(entity.date, monthFormat)
            guard let monthInDate = dateService.parseDate(monthInString, monthFormat) else {
                fatalError()
            }
            let expense = Expense(id: entity.id,
                                  title: entity.title,
                                  amount: entity.amount,
                                  createdUser: entity.createdUser,
                                  users: entity.users,
                                  rate: entity.rate,
                                  date: entity.date)
            hash[monthInDate, default: []].append(expense)
        }
        return hash
    }
}
