//
//  ExpenseCell.swift
//  Monivide
//
//  Created by Chung Nguyen on 7/1/22.
//

import Foundation
import UIKit

class ExpenseCell: UITableViewCell {
    static let id = "ExpenseCell"
    var viewModel:ExpenseCellViewModel = ExpenseCellViewModelImpl()
    
    lazy var monthLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var dayLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var categoryImageView: UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var tranLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var tranTypeLabel: UILabel = {
        return UILabel()
    }()
    
    lazy var tranAmountLabel: UILabel = {
        return UILabel()
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupAutolayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        monthLabel.text = nil
        dayLabel.text = nil
        categoryImageView.image = nil
        titleLabel.text = nil
        tranLabel.text = nil
        tranTypeLabel.text = nil
        tranAmountLabel.text = nil
    }
    
    func setupViews() {
        monthLabel.font = .systemFont(ofSize: 12, weight: .thin)
        monthLabel.textColor = .systemGray
        contentView.addSubview(monthLabel)
        
        dayLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        dayLabel.textColor = .systemGray
        contentView.addSubview(dayLabel)
        
        categoryImageView.contentMode = .scaleAspectFit
        contentView.addSubview(categoryImageView)
        
        titleLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        titleLabel.textColor = .label
        contentView.addSubview(titleLabel)
        
        tranLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tranLabel.textColor = .systemGray
        contentView.addSubview(tranLabel)
        
        tranTypeLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        tranTypeLabel.textColor = .systemGreen
        contentView.addSubview(tranTypeLabel)
        
        tranAmountLabel.font = .systemFont(ofSize: 15, weight: .semibold)
        tranAmountLabel.textColor = .systemGreen
        contentView.addSubview(tranAmountLabel)
    }
    
    func setupAutolayout() {
        monthLabel.translatesAutoresizingMaskIntoConstraints = false
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        tranLabel.translatesAutoresizingMaskIntoConstraints = false
        tranTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        tranAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            monthLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10.0),
            monthLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0),
            
            dayLabel.centerXAnchor.constraint(equalTo: monthLabel.centerXAnchor),
            dayLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0),
            
            categoryImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40.0),
            categoryImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8),
            categoryImageView.widthAnchor.constraint(equalTo: categoryImageView.heightAnchor, multiplier: 1.0),
            
            titleLabel.leadingAnchor.constraint(equalTo: categoryImageView.trailingAnchor, constant: 10.0),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0),
            titleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            tranLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            tranLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0),
            tranLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4),
            
            tranTypeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10.0),
            tranTypeLabel.bottomAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0),
            
            tranAmountLabel.trailingAnchor.constraint(equalTo: tranTypeLabel.trailingAnchor),
            tranAmountLabel.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0.0),
        ])
    }
    
    func configure(_ expense: Expense) {
        let dayDisplay = viewModel.getDayDisplay(expense.date)
        let parts = dayDisplay.components(separatedBy: " ")
        guard parts.count == 2 else {
            return
        }
        let isPaid = expense.currentAmountDifferent > 0
        
        monthLabel.text = String(parts[0])
        dayLabel.text = String(parts[1])
        categoryImageView.image = UIImage(named: "cart")
        titleLabel.text = expense.title
        
        let tranPrefix = isPaid ? "You paid" : "\(expense.paid.abbrLastName()) paid"
        tranLabel.text = tranPrefix + " " + expense.currentAmountDifferent.moneyFormat
        tranLabel.textColor = isPaid ? .systemGreen : .systemRed
        
        tranTypeLabel.text = isPaid ? "You lent" : "You borrowed"
        tranTypeLabel.textColor = isPaid ? .systemGreen : .systemRed
        
        tranAmountLabel.text = expense.currentAmountDifferent.moneyFormat
        tranAmountLabel.textColor = isPaid ? .systemGreen : .systemRed
    }
}
