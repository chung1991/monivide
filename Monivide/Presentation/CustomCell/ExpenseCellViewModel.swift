//
//  ExpenseCellViewModel.swift
//  Monivide
//
//  Created by Chung Nguyen on 7/7/22.
//

import Foundation

protocol ExpenseCellViewModel {
    func getDayDisplay(_ date: Date) -> String
}

class ExpenseCellViewModelImpl: ExpenseCellViewModel {
    let dateService: DateUtils = DateUtilsImpl()
    func getDayDisplay(_ date: Date) -> String {
        let dayFormat = "MMM d"
        return dateService.getDateString(date, dayFormat)
    }
}
