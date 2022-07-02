//
//  FriendDetailsViewModel.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation
import OrderedCollections

enum ExpenseOption {
    case lend
    case borrow
}

protocol FriendDetailsViewModelDelegate: AnyObject {
    func didGetTransaction()
}

class FriendDetailsViewModel {
    var service = MoneyService.shared
    let dateService = DateService()
    
    var currentUser: User?
    var currentAmount = 0.0
    var currentTransactions: OrderedDictionary<Date, [Transaction]> = [:] {
        didSet {
            currentAmount = 0.0
            for transaction in currentTransactions.values.flatMap({ $0 }) {
                currentAmount += transaction.amount
            }
            delegate?.didGetTransaction()
        }
    }
    var selectedUser: User?
    weak var delegate: FriendDetailsViewModelDelegate?
    
    func load() {
        if let user = service.getCurrentUser() {
            currentUser = user
            currentTransactions = service.getTransactions(by: user.username)
        }

        selectedUser = service.getSelectedUser()
    }

//    func addExpense(_ amount: Double, _ option: ExpenseOption) {
//        guard let currentUser = currentUser,
//              let selectedUser = selectedUser else {
//            return
//        }
//        if option == .lend {
//            service.addExpense(currentUser, selectedUser, amount)
//        } else {
//            service.addExpense(selectedUser, currentUser, amount)
//        }
//    }
    
    func getMonthDisplay(_ date: Date) -> String {
        let monthFormat = "MMMM yyyy"
        return dateService.getDateString(date, monthFormat)
    }
}
