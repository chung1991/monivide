//
//  ViewController.swift
//  Monivide
//
//  Created by Chung EXI-Nguyen on 6/29/22.
//

import UIKit

// feature
// - borrow money
// - lend money

struct User: Equatable {
    let username: String
}

struct Tracsaction {
    let id: UUID
    let amount: Double
    let paid: User
    let owned: User
    let date: Date
}

// chung - lends - hanh
// Tran {
//      amount: 10
//      paid:   chung
//      owned:  hanh
// }

// chung - borrow - hanh
// Tran {
//      amount: 10
//      paid:   hanh
//      owned:  chung
// }

class UserDataAccess {
    static let shared = UserDataAccess()

    func getCurrentUser() -> User? {
        return User(username: "chung1991")
    }
    
    func getSelectedUser() -> User? {
        return User(username: "hanhnv")
    }
}

class MoneyDataAccess {
    static let shared = MoneyDataAccess()
    let userDataAccess = UserDataAccess()
    var database: [Tracsaction] = []
    
    func addExpense(_ paid: User, _ owned: User, _ amount: Double, _ date: Date) {
        database.append(Tracsaction(id: UUID(),
                                    amount: amount,
                                    paid: paid,
                                    owned: owned,
                                    date: date))
    }
    
    func getTransactions(by username: String) -> [Tracsaction] {
        for _ in 0..<10 {
            let randomAmount = Double.random(in: 1.0...30.0)
            let randomPaid = [userDataAccess.getCurrentUser(), userDataAccess.getSelectedUser()].randomElement()!
            let randomOwned = randomPaid == userDataAccess.getCurrentUser() ? userDataAccess.getSelectedUser() : userDataAccess.getCurrentUser()
            let randomDiff = Int.random(in: -2...2)
            database.append(Tracsaction(id: UUID(),
                                        amount: randomAmount,
                                        paid: randomPaid!,
                                        owned: randomOwned!,
                                        date: DateService().getDateFrom(Date(), randomDiff)))
        }
        
        return database.filter { $0.paid.username == username || $0.owned.username == username }
    }
}

class MoneyService {
    static let shared = MoneyService()
    let dateService = DateService()
    var moneyDataAccess = MoneyDataAccess()
    let userDataAccess = UserDataAccess()
    
    func getCurrentUser() -> User? {
        return userDataAccess.getCurrentUser()
    }
    
    func getSelectedUser() -> User? {
        return userDataAccess.getSelectedUser()
    }

    func addExpense(_ paid: User, _ owned: User, _ amount: Double) {
        let randomDiff = Int.random(in: -40...40)
        let date = dateService.getDateFrom(Date(), randomDiff)
        moneyDataAccess.addExpense(paid, owned, amount, date)
    }
    
    func getTransactions(by username: String) -> [Tracsaction] {
        moneyDataAccess.getTransactions(by: username)
    }
}

enum ExpenseOption {
    case lend
    case borrow
}

protocol ViewModelDelegate: AnyObject {
    func didGetTransaction()
}

class ViewModel {
    var service = MoneyService.shared
    var currentUser: User?
    var currentAmount = 0.0
    var currentTransaction: [Tracsaction] = [] {
        didSet {
            if let currentUser = currentUser {
                currentAmount = 0.0
                for transaction in currentTransaction {
                    currentAmount += transaction.paid.username == currentUser.username ? transaction.amount : -transaction.amount
                }
                delegate?.didGetTransaction()
            }
        }
    }
    var selectedUser: User?
    weak var delegate: ViewModelDelegate?
    
    func load() {
        if let user = service.getCurrentUser() {
            currentUser = user
            currentTransaction = service.getTransactions(by: user.username)
        }

        selectedUser = service.getSelectedUser()
    }

    func addExpense(_ amount: Double, _ option: ExpenseOption) {
        guard let currentUser = currentUser,
              let selectedUser = selectedUser else {
            return
        }
        if option == .lend {
            service.addExpense(currentUser, selectedUser, amount)
        } else {
            service.addExpense(selectedUser, currentUser, amount)
        }
    }
}

class ViewController: UIViewController {
    
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
        return UITableView()
    }()
    
    lazy var addExpenseButton: UIButton = {
        return UIButton()
    }()
    
    var viewModel = ViewModel()
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
        avatarImageView.contentMode = .scaleAspectFit
        view.addSubview(avatarImageView)
        
        nameLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        nameLabel.textColor = .label
        view.addSubview(nameLabel)
        
        ownTitleLabel.font = .systemFont(ofSize: 12)
        ownTitleLabel.textColor = .label
        view.addSubview(ownTitleLabel)
    
        ownValueLabel.font = .systemFont(ofSize: 12)
        ownValueLabel.textColor = .systemGreen
        view.addSubview(ownValueLabel)
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        view.addSubview(tableView)
        
        addExpenseButton.layer.cornerRadius = 10.0
        addExpenseButton.setTitle("Add Expense", for: .normal)
        addExpenseButton.setTitleColor(.label, for: .normal)
        addExpenseButton.backgroundColor = .systemGreen
        view.addSubview(addExpenseButton)
    }
    
    func setupAutolayout() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        ownTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        ownValueLabel.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        addExpenseButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30.0),
            avatarImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0),
            avatarImageView.widthAnchor.constraint(equalToConstant: 40.0),
            avatarImageView.heightAnchor.constraint(equalToConstant: 40.0),
            
            nameLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 20.0),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0),
            
            ownTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10.0),
            ownTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0),
            
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
        viewModel.delegate = self
    }
    
    
    @objc func didTapButton() {
        
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.currentTransaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let model = viewModel.currentTransaction[indexPath.row]
        cell.textLabel?.text = "\(model.amount.moneyFormat)"
        return cell
    }
}

extension ViewController: ViewModelDelegate {
    func didGetTransaction() {
        mainQueue.async { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.avatarImageView.image = UIImage(systemName: "person")
            self.nameLabel.text = self.viewModel.selectedUser?.username
            if let selectedUsername = self.viewModel.selectedUser?.username {
                if self.viewModel.currentAmount > 0 {
                    self.ownTitleLabel.text = selectedUsername + " owes you"
                    self.ownValueLabel.text = "\(self.viewModel.currentAmount.moneyFormat)"
                    self.ownValueLabel.textColor = .systemGreen
                } else {
                    self.ownTitleLabel.text = selectedUsername + " lends you"
                    self.ownValueLabel.text = "\(self.viewModel.currentAmount.moneyFormat)"
                    self.ownValueLabel.textColor = .systemRed
                }
            }
        }
    }
}

extension Double {
    var moneyFormat: String {
        let val = abs(self)
        return String(format: "%.2f", val)
    }
}

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
