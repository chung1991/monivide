//
//  FriendDetailsViewModel.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation
import OrderedCollections

protocol FriendDetailsViewModelDelegate: AnyObject {
    func didGetTransaction()
}

protocol FriendDetailsViewModel {
    var moneyService: MoneyService { get set }
    var userService: UserService { get set }
    var dateUtils: DateUtils { get set }
    var delegate: FriendDetailsViewModelDelegate? { get set }
    
    var currentUser: User? { get set }
    var selectedUser: User? { get set }
    var currentAmount: Double { get set }
    var currentExpenses: OrderedDictionary<Date, [Expense]> { get set }
    
    func load()
    func getMonthDisplay(_ date: Date) -> String
}

class FriendDetailsViewModelImpl: FriendDetailsViewModel {
    var moneyService: MoneyService = {
        let userDataSource = UserDataSourceImpl()
        let expenseDataSource = ExpenseDataSourceImpl()
        let dateUtils = DateUtilsImpl()
        let moneyDataAccess = MoneyDataAccessImpl(userDataSource: userDataSource,
                                                  expenseDataSource: expenseDataSource)
        return MoneyServiceImpl(dateService: dateUtils,
                                moneyDataAccess: moneyDataAccess)
    }()
    var userService: UserService = {
        let userDataSource = UserDataSourceImpl()
        let userDataAccess = UserDataAccessImpl(userDataSource: userDataSource)
        return UserServiceImpl(userDataAccess: userDataAccess)
    }()
    var dateUtils: DateUtils = DateUtilsImpl()
    
    var currentUser: User?
    var selectedUser: User?
    var currentAmount = 0.0
    var currentExpenses: OrderedDictionary<Date, [Expense]> = [:] {
        didSet {
            guard let username = currentUser?.username else { fatalError() }
            currentAmount = 0.0
            for expense in currentExpenses.values.flatMap({ $0 }) {
                currentAmount += expense.getAmountDifferent(username)
            }
            delegate?.didGetTransaction()
        }
    }
    
    weak var delegate: FriendDetailsViewModelDelegate?
    
    func load() {
        // TODO: hard code, fix later
        if let user = userService.getUserByUsername("Chung Nguyen"),
           let selectedUser = userService.getUserByUsername("Hanh Nguyen") {
            currentUser = user
            self.selectedUser = selectedUser
            currentExpenses = moneyService.getExpenses(by: user.username)
        }
    }

    func getMonthDisplay(_ date: Date) -> String {
        let monthFormat = "MMMM yyyy"
        return dateUtils.getDateString(date, monthFormat)
    }
}
