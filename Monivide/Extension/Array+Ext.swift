//
//  Array+Ext.swift
//  Monivide
//
//  Created by Chung Nguyen on 7/1/22.
//

import Foundation
import UIKit

extension Array where Element == Double {
    func color() -> UIColor {
        guard self.count == 3 else { return .systemBackground }
        return UIColor(displayP3Red: CGFloat(self[0]/255.0),
                       green: CGFloat(self[1]/255.0),
                       blue: CGFloat(self[2]/255.0),
                       alpha: 1)
    }
}
