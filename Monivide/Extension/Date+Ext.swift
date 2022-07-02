//
//  Date+Ext.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation

extension Double {
    var moneyFormat: String {
        let val = abs(self)
        return "$" + String(format: "%.2f", val)
    }
}
