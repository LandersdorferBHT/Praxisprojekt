//
//  ProductSelectionCell.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 16.02.25.
//

import UIKit

class ProductSelectionCell: UITableViewCell {
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .label
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stockLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(categoryLabel)
        contentView.addSubview(stockLabel)
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            stockLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 4),
            stockLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stockLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stockLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with category: String, stockCount: Int) {
        let symbolName: String
        switch category {
        case "iPhone":
            symbolName = "iphone"
        case "iPad":
            symbolName = "ipad"
        case "Apple Watch":
            symbolName = "applewatch"
        case "AirPods":
            symbolName = "airpods"
        default:
            symbolName = "tag"
        }
        
        categoryLabel.setTextWithSFSymbol(symbolName: symbolName, text: category, color: .systemBlue)
        stockLabel.text = "\(stockCount) Stück lagernd"
    }
}


extension UILabel {
    func setTextWithSFSymbol(symbolName: String, text: String, imageSize: CGFloat = 16, weight: UIImage.SymbolWeight = .regular, color: UIColor) {
        let attachment = NSTextAttachment()
        if let image = UIImage(systemName: symbolName)?.withTintColor(color) {
            attachment.image = image.withConfiguration(UIImage.SymbolConfiguration(pointSize: imageSize, weight: weight))
            
        }
        let attachmentString = NSAttributedString(attachment: attachment)
        let textString = NSAttributedString(string: " \(text)")
        let completeString = NSMutableAttributedString()
        completeString.append(attachmentString)
        completeString.append(textString)
        self.attributedText = completeString
    }
}



