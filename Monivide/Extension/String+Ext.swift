//
//  String+Ext.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation

extension String {
    static func randomWord(wordLength: Int = 6) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((1..<wordLength).map{ _ in letters.randomElement()! })
    }
}
