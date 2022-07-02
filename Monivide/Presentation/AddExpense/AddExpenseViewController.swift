//
//  AddExpenseViewController.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 7/1/22.
//

import Foundation
import UIKit

class AddExpenseViewController: UIViewController {
    lazy var expenseLabel: UILabel = {
        return UILabel()
    }()
    lazy var amountLabel: UILabel = {
        return UILabel()
    }()
    lazy var expenseTextfield: UITextField = {
        return UITextField()
    }()
    lazy var amountTextfield: UITextField = {
        return UITextField()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAutolayout()
    }
    
    func setupViews() {
        view.addSubview(expenseLabel)
        view.addSubview(amountLabel)
        
        expenseTextfield.layer.borderWidth = 1
        view.addSubview(expenseTextfield)
        
        amountTextfield.layer.borderWidth = 1
        view.addSubview(amountTextfield)
    }
    
    func setupAutolayout() {
        expenseLabel.translatesAutoresizingMaskIntoConstraints = false
        expenseTextfield.translatesAutoresizingMaskIntoConstraints = false
        amountLabel.translatesAutoresizingMaskIntoConstraints = false
        amountTextfield.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
        ])
    }
}
