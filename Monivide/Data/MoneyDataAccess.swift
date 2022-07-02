//
//  MoneyDataAccess.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation

class MoneyDataAccess {
    static let shared = MoneyDataAccess()
    let userDataAccess = UserDataAccess()
    let dateService = DateService()
    var database: [TransactionEntity] = []
    
    func addExpense(_ paid: UserEntity, _ owned: UserEntity, _ title: String, _ amount: Double, _ date: Date) {
        database.append(TransactionEntity(id: UUID(),
                                          title: title,
                                          amount: amount,
                                          paid: paid,
                                          owned: owned,
                                          date: date))
    }
    
    func getTransactions(by username: String) -> [TransactionEntity] {
        for _ in 0..<10 {
            let randomSentenceLength = Int.random(in: 1...3)
            var titles: [String] = []
            for _ in 0..<randomSentenceLength {
                let randomWordLength = Int.random(in: 4...8)
                titles.append(String.randomWord(wordLength: randomWordLength))
            }
            let randomAmount = Double.random(in: 1.0...30.0)
            let randomPaid = [userDataAccess.getCurrentUser(), userDataAccess.getSelectedUser()].randomElement()!
            let randomOwned = randomPaid == userDataAccess.getCurrentUser() ? userDataAccess.getSelectedUser() : userDataAccess.getCurrentUser()
            let randomDiff = Int.random(in: -2...2)
            database.append(TransactionEntity(id: UUID(),
                                              title: titles.joined(separator: " "),
                                              amount: randomAmount,
                                              paid: randomPaid!,
                                              owned: randomOwned!,
                                              date: dateService.getDateFrom(Date(), randomDiff)))
        }
        
        return database.filter { $0.paid.username == username || $0.owned.username == username }
    }
}
