//
//  DetailDocumentCell.swift
//  Product Analysis
//
//  Created by Anton Landersdorfer on 04.03.25.
//


import UIKit

protocol DocumentCellDelegate: AnyObject {
    func didTapImageView(_ imageView: UIImageView)
}

class DetailDocumentCell: UITableViewCell, DocumentCellDelegate {
    func didTapImageView(_ imageView: UIImageView) {
        
    }
    

    weak var delegate: DocumentCellDelegate?
    
    private let documentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit // Verwenden von .scaleAspectFill für bessere Skalierung
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.systemBlue.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.addSubview(documentImageView)
        
        self.selectionStyle = .none
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        documentImageView.isUserInteractionEnabled = true
        documentImageView.addGestureRecognizer(tapGesture)
        
        NSLayoutConstraint.activate([
            documentImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            documentImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            documentImageView.widthAnchor.constraint(equalToConstant: 80),
            documentImageView.heightAnchor.constraint(equalToConstant: 80),
            documentImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -10)
        ])
        
        
        
    }
    
    @objc private func imageTapped() {
        delegate?.didTapImageView(documentImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with image: UIImage) {
        documentImageView.image = image
    }
}


