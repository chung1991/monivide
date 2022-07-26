//
//  AddExpenseViewController.swift
//  Monivide
//
//  Created by Chung Nguyen on 7/1/22.
//

import Foundation
import UIKit

enum ExpenseCategory: String {
    case note = "note.text"
}

enum ExpenseCurrency: String {
    case dollar = "dollarsign.circle"
}

enum ExpenseDivideOption {
    case lendsFull
    case ownedFull
}

protocol AddExpenseViewModelDelegate: AnyObject {
    func expenseOptionUpdated()
}

class AddExpenseViewModel {
    var selectedCurrency: ExpenseCurrency = .dollar
    var selectedCategory: ExpenseCategory = .note
    var selectedDivideOption: ExpenseDivideOption = .lendsFull
    var selectedUser: String?
    weak var delegate: AddExpenseViewModelDelegate?
    
    func load() {
        selectedCurrency = .dollar
        selectedCategory = .note
        delegate?.expenseOptionUpdated()
    }
    
    func getSelectedDivideOptionDisplay() -> String {
        guard let selectedUser = selectedUser else {
            return ""
        }
        switch selectedDivideOption {
        case .lendsFull:
            return "\(selectedUser) owes you the full total"
        case .ownedFull:
            return "You owe \(selectedUser) the full total"
        }
    }
}

class AddExpenseViewController: UIViewController {
    
    lazy var cancelButtonItem: UIBarButtonItem = {
        return UIBarButtonItem()
    }()
    
    lazy var saveButtonItem: UIBarButtonItem = {
        return UIBarButtonItem()
    }()
    
    lazy var expenseCategoryLabel: UIButton = {
        return UIButton()
    }()
    lazy var expenseCurrencyLabel: UIButton = {
        return UIButton()
    }()
    lazy var expenseTitleValue: UITextField = {
        return UITextField()
    }()
    lazy var expenseAmountValue: UITextField = {
        return UITextField()
    }()
    lazy var expenseDivideOptionLabel: UIButton = {
        return UIButton()
    }()
    let viewModel = AddExpenseViewModel()
    let mainQueue = DispatchQueue.main
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupAutolayout()
        setupDelegates()
        viewModel.load()
    }
    
    func setupViews() {
        view.backgroundColor = .systemBackground
        
        navigationItem.titleView?.tintColor = .green
        
        self.title = "Add an expense"
        
        cancelButtonItem = UIBarButtonItem(title: "X",
                                           image: nil,
                                           primaryAction: nil,
                                           menu: nil)
        saveButtonItem = UIBarButtonItem(title: "Save",
                                         image: nil,
                                         primaryAction: nil,
                                         menu: nil)
        navigationItem.setLeftBarButton(cancelButtonItem, animated: false)
        navigationItem.setRightBarButton(saveButtonItem, animated: false)
        
        view.addSubview(expenseCategoryLabel)
        view.addSubview(expenseCurrencyLabel)
        
        expenseTitleValue.layer.borderWidth = 1
        expenseTitleValue.placeholder = "Enter a description"
        view.addSubview(expenseTitleValue)
        
        expenseAmountValue.layer.borderWidth = 1
        expenseAmountValue.placeholder = "0.00"
        view.addSubview(expenseAmountValue)
        
        expenseDivideOptionLabel.setTitleColor(.label,
                                               for: .normal)
        view.addSubview(expenseDivideOptionLabel)
    }
    
    func setupAutolayout() {
        expenseCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        expenseTitleValue.translatesAutoresizingMaskIntoConstraints = false
        expenseCurrencyLabel.translatesAutoresizingMaskIntoConstraints = false
        expenseAmountValue.translatesAutoresizingMaskIntoConstraints = false
        expenseDivideOptionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            expenseCategoryLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            expenseCategoryLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100.0),
            expenseCategoryLabel.widthAnchor.constraint(equalToConstant: 40.0),
            expenseCategoryLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            expenseCurrencyLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
            expenseCurrencyLabel.topAnchor.constraint(equalTo: expenseCategoryLabel.bottomAnchor, constant: 10.0),
            expenseCurrencyLabel.widthAnchor.constraint(equalToConstant: 40.0),
            expenseCurrencyLabel.heightAnchor.constraint(equalToConstant: 40.0),
            
            expenseTitleValue.leadingAnchor.constraint(equalTo: expenseCategoryLabel.trailingAnchor, constant: 5.0),
            expenseTitleValue.centerYAnchor.constraint(equalTo: expenseCategoryLabel.centerYAnchor),
            expenseTitleValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            
            expenseAmountValue.leadingAnchor.constraint(equalTo: expenseCurrencyLabel.trailingAnchor, constant: 5.0),
            expenseAmountValue.centerYAnchor.constraint(equalTo: expenseCurrencyLabel.centerYAnchor),
            expenseAmountValue.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
            
            expenseDivideOptionLabel.topAnchor.constraint(equalTo: expenseCurrencyLabel.bottomAnchor, constant: 10.0),
            expenseDivideOptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupDelegates() {
        viewModel.delegate = self
    }
    
    func reloadData() {
        expenseCategoryLabel.setImage(UIImage(systemName: viewModel.selectedCategory.rawValue),
                              for: .normal)
        expenseCurrencyLabel.setImage(UIImage(systemName: viewModel.selectedCurrency.rawValue),
                             for: .normal)
        expenseDivideOptionLabel.setTitle(viewModel.getSelectedDivideOptionDisplay(),
                                          for: .normal)
        
    }
    
    func configure(_ username: String?) {
        viewModel.selectedUser = username
    }
}

extension AddExpenseViewController: AddExpenseViewModelDelegate {
    func expenseOptionUpdated() {
        mainQueue.async { [weak self] in
            self?.reloadData()
        }
    }
}
