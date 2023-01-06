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
        label.backgroundColor = .red
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
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
