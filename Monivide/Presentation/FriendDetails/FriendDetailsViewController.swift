//
//  ViewController.swift
//  Monivide
//
//  Created by Chung Nguyen on 6/29/22.
//

import UIKit

class FriendDetailsViewController: UIViewController {
    
    lazy var topView: UIView = {
        return UIView()
    }()
    
    lazy var avatarImageView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var nameLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var ownTitleLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var ownValueLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var tableView: UITableView = {
        return UITableView(frame: .zero, style: .grouped) // .group to disable stick header
    }()
    
    lazy var addExpenseButton: UIButton = {
        return UIButton()
    }()
    
    var viewModel: FriendDetailsViewModel = FriendDetailsViewModelImpl()
    
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
        topView.backgroundColor = [0.0, 121.0, 98.0].color()
        view.addSubview(topView)
        
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.backgroundColor = .systemRed
        avatarImageView.tintColor = .systemBackground
        avatarImageView.layer.cornerRadius = 40.0
        avatarImageView.layer.borderWidth = 5.0
        avatarImageView.layer.borderColor = UIColor.systemBackground.cgColor
        avatarImageView.layer.masksToBounds = true // see different
        view.addSubview(avatarImageView)
        
        nameLabel.font = .systemFont(ofSize: 30, weight: .semibold)
        nameLabel.textColor = .label
        view.addSubview(nameLabel)
        
        ownTitleLabel.font = .systemFont(ofSize: 24)
        ownTitleLabel.textColor = .label
        view.addSubview(ownTitleLabel)
    
        ownValueLabel.font = .systemFont(ofSize: 24)
        ownValueLabel.textColor = .systemGreen
        view.addSubview(ownValueLabel)
        
        tableView.register(ExpenseCell.self, forCellReuseIdentifier: ExpenseCell.id)
        view.addSubview(tableView)
        
        addExpenseButton.layer.cornerRadius = 10.0
        addExpenseButton.setTitle("Add Expense", for: .normal)
        addExpenseButton.setTitleColor(.label, for: .normal)
        addExpenseButton.backgroundColor = .systemGreen
        view.addSubview(addExpenseButton)
    }
    
    func setupAutolayout() {
        topView.translatesAutoresizingMaskIntoConstraints = false
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ownTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ownValueLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addExpenseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            topView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0.0),
            topView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0.0),
            topView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0.0),
            topView.heightAnchor.constraint(equalToConstant: 100),
            
            avatarImageView.centerYAnchor.constraint(equalTo: topView.bottomAnchor),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 80.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 80.0),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20.0),
            nameLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: 0.0),
            
            ownTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.0),
            ownTitleLabel.leadingAnchor.constraint(equalTo: avatarImageView.leadingAnchor, constant: 0.0),
            
            ownValueLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.0),
            ownValueLabel.leadingAnchor.constraint(equalTo: ownTitleLabel.trailingAnchor, constant: 5.0),
            
            tableView.topAnchor.constraint(equalTo: ownValueLabel.bottomAnchor, constant: 20.0),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 5.0),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.0),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0.0),
            
            addExpenseButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -5.0),
            addExpenseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20.0),
            addExpenseButton.widthAnchor.constraint(equalToConstant: 150.0),
            addExpenseButton.heightAnchor.constraint(equalToConstant: 30.0)
        ])
    }
    
    func setupDelegates() {
        addExpenseButton.addTarget(self,
                                   action: #selector(didTapButton),
                                   for: .touchUpInside)
        tableView.dataSource = self
        tableView.delegate = self
        viewModel.delegate = self
    }
    
    
    @objc func didTapButton() {
        let vc = AddExpenseViewController()
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        vc.configure(viewModel.selectedUser?.username)
        present(nav, animated: true, completion: nil)
    }
}

extension FriendDetailsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50.0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let month = viewModel.currentExpenses.keys[section]
        return viewModel.getMonthDisplay(month)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.currentExpenses.keys.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = viewModel.currentExpenses.keys[section]
        let transactions = viewModel.currentExpenses[month]
        return transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let month = viewModel.currentExpenses.keys[indexPath.section]
        guard let transactions = viewModel.currentExpenses[month],
              let cell = tableView.dequeueReusableCell(withIdentifier: ExpenseCell.id, for: indexPath) as? ExpenseCell else {
            return UITableViewCell()
        }
        
        let transaction = transactions[indexPath.row]
        cell.configure(transaction)
        return cell
    }
}

extension FriendDetailsViewController: FriendDetailsViewModelDelegate {
    func didGetTransaction() {
        mainQueue.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.avatarImageView.image = UIImage(systemName: "person")
            self.nameLabel.text = self.viewModel.selectedUser?.username
            if let selectedUsername = self.viewModel.selectedUser?.username {
                if self.viewModel.currentAmount > 0 {
                    self.ownTitleLabel.text = selectedUsername.abbrLastName() + " owes you"
                    self.ownValueLabel.text = "\(self.viewModel.currentAmount.moneyFormat)"
                    self.ownValueLabel.textColor = .systemGreen
                } else {
                    self.ownTitleLabel.text = selectedUsername.abbrLastName() + " lends you"
                    self.ownValueLabel.text = "\(self.viewModel.currentAmount.moneyFormat)"
                    self.ownValueLabel.textColor = .systemRed
                }
            }
        }
    }
}

