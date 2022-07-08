//
//  Database.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/6/22.
//

import Foundation

class Database {
    static let shared = Database()
    let dateService = DateUtilsImpl()
    var users: [String:UserEntity] = [:]
    var expenses: [ExpenseEntity] = []
    
    init() {
        let user1 = UserEntity(username: "Chung Nguyen")
        let user2 = UserEntity(username: "Hanh Nguyen")
        users[user1.username] = user1
        users[user2.username] = user2
        
        for _ in 0..<20 {
            let randomSentenceLength = Int.random(in: 1...3)
            var titles: [String] = []
            for _ in 0..<randomSentenceLength {
                let randomWordLength = Int.random(in: 4...8)
                titles.append(String.randomWord(wordLength: randomWordLength))
            }
            let randomAmount = Double.random(in: 1.0...30.0)
            let randomDiff = Int.random(in: -90...0)
            let randomRate = [1.0,0.0].shuffled()
            
            expenses.append(ExpenseEntity(id: UUID(),
                                          title: titles.joined(separator: " "),
                                          amount: randomAmount,
                                          createdUser: user1.username,
                                          users: [user1.username, user2.username],
                                          rate: randomRate,
                                          date: dateService.getDateFrom(Date(), randomDiff)))
        }
    }
}
