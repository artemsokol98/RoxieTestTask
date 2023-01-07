//
//  DetailInfoCollectionViewCell.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 06.01.2023.
//

import UIKit

class DetailInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailInfoCollectionViewCell"
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        contentView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        contentView.layer.cornerRadius = contentView.bounds.width * 0.2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
    
    func configureCell(string: String) {
        label.text = string
    }
    
}
