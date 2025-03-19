//
//  ProductDetailCell.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 05.03.25.
//

import UIKit

class ProductDetailCell: UITableViewCell {
    
    private let storageLabel = UILabel()
    private let stockLabel = UILabel()
    private let soldLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // Configure Labels
        storageLabel.font = UIFont.boldSystemFont(ofSize: 18)
        stockLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        soldLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
        
        // Add Labels to the ContentView
        contentView.addSubview(storageLabel)
        contentView.addSubview(stockLabel)
        contentView.addSubview(soldLabel)
        
        // Set up constraints or frames for labels (using AutoLayout or manual frames)
        storageLabel.translatesAutoresizingMaskIntoConstraints = false
        stockLabel.translatesAutoresizingMaskIntoConstraints = false
        soldLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // Constraints for labels
        NSLayoutConstraint.activate([
            storageLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            storageLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            storageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            stockLabel.topAnchor.constraint(equalTo: storageLabel.bottomAnchor, constant: 4),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            soldLabel.topAnchor.constraint(equalTo: stockLabel.bottomAnchor, constant: 4),
            soldLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            soldLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            soldLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with storage: String, stockCount: Int, soldCount: Int) {
        storageLabel.text = storage
        stockLabel.text = "Lagernd: \(stockCount)"
        soldLabel.text = "Verkauft: \(soldCount)"
    }
}

