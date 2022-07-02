//
//  MoneyService.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation
import OrderedCollections

class MoneyService {
    static let shared = MoneyService()
    let dateService = DateService()
    var moneyDataAccess = MoneyDataAccess()
    let userDataAccess = UserDataAccess()
    
    func getCurrentUser() -> User? {
        guard let userEntity = userDataAccess.getCurrentUser() else { return nil }
        return User(username: userEntity.username)
    }
    
    func getSelectedUser() -> User? {
        guard let userEntity = userDataAccess.getSelectedUser() else { return nil }
        return User(username: userEntity.username)
    }

//    func addExpense(_ paid: User, _ owned: User, _ amount: Double) {
//        let randomDiff = Int.random(in: -40...40)
//        let date = dateService.getDateFrom(Date(), randomDiff)
//        moneyDataAccess.addExpense(paid, owned, amount, date)
//    }
    
    
    /// Return ordered dictionary:
    /// - key: order by month of transaction ASC
    /// - values: order by transaction date ASC
    func getTransactions(by username: String) -> OrderedDictionary<Date, [Transaction]> {
        let transactionEntities = moneyDataAccess.getTransactions(by: username)
        var hash: OrderedDictionary<Date, [Transaction]> = [:]
        let monthFormat = "MMMM yyyy"
        for transactionEntity in transactionEntities {
            let monthInString = dateService.getDateString(transactionEntity.date, monthFormat)
            guard let monthInDate = dateService.parseDate(monthInString, monthFormat) else {
                fatalError()
            }
            let amount = transactionEntity.paid.username == username ? transactionEntity.amount : -transactionEntity.amount
            let transaction = Transaction(id: transactionEntity.id,
                                          title: transactionEntity.title,
                                          amount: amount,
                                          paid: transactionEntity.paid.username,
                                          owned: transactionEntity.owned.username,
                                          date: transactionEntity.date)
            hash[monthInDate, default: []].append(transaction)
        }
        for (monthDate, _) in hash {
            hash[monthDate]?.sort { $0.date < $1.date }
        }
        return hash
    }
}
