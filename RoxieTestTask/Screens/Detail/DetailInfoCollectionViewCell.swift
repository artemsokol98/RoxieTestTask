//
//  DetailInfoCollectionViewCell.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 06.01.2023.
//

import UIKit

class DetailInfoCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "DetailInfoCollectionViewCell"
    
    lazy var nameOfCellLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 12.0)
        return label
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(infoLabel)
        contentView.addSubview(nameOfCellLabel)
        contentView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 0.5, alpha: 1)
        contentView.layer.cornerRadius = contentView.bounds.width * 0.1
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        infoLabel.translatesAutoresizingMaskIntoConstraints = false
        nameOfCellLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelConstraints = [
            infoLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            infoLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            infoLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            infoLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        let nameOfCellLabelConstraints = [
            nameOfCellLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: contentView.bounds.width * 0.1),
            nameOfCellLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameOfCellLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -contentView.bounds.height * 0.8),
            nameOfCellLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: contentView.bounds.width * 0.5)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(nameOfCellLabelConstraints)
    }
    
    func configureCell(model: CollectionViewCellModel) {
        nameOfCellLabel.text = model.nameOfCell
        infoLabel.text = model.infoLabel
    }
    
}
