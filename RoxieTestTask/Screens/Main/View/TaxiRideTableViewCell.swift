//
//  TaxiRideTableViewCell.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 02.01.2023.
//

import UIKit

class TaxiRideTableViewCell: UITableViewCell {

    static let identifier = "TaxiRideIdentifier"
    
    private lazy var leftVerticalStackView: UIStackView = {
        let startAddress = UILabel()
        startAddress.numberOfLines = 0
        let endAddress = UILabel()
        endAddress.numberOfLines = 0
        let dateRide = UILabel()
        dateRide.numberOfLines = 0
        let costRide = UILabel()
        costRide.numberOfLines = 0
        
        let stackView = UIStackView()
        startAddress.text = "Начальный адрес"
        stackView.addArrangedSubview(startAddress)
        endAddress.text = "Конечный адрес"
        stackView.addArrangedSubview(endAddress)
        dateRide.text = "Дата поездки"
        stackView.addArrangedSubview(dateRide)
        costRide.text = "Стоимость поездки"
        stackView.addArrangedSubview(costRide)
        
        return stackView
    }()
    
    private lazy var rightVerticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(startAddress)
        stackView.addArrangedSubview(endAddress)
        stackView.addArrangedSubview(dateRide)
        stackView.addArrangedSubview(costRide)
        return stackView
    }()
    
    private lazy var startAddress: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var endAddress: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateRide: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var costRide: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(rightVerticalStackView)
        contentView.addSubview(leftVerticalStackView)
        contentView.layer.cornerRadius = contentView.bounds.width * Constants.collectionViewCellCornerRadiusMultiplier
        contentView.backgroundColor = Color.lightYellowColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(
            top: Constants.nameAndPhotoElementCellEdgeInset,
            left: Constants.nameAndPhotoElementCellEdgeInset,
            bottom: Constants.nameAndPhotoElementCellEdgeInset,
            right: Constants.nameAndPhotoElementCellEdgeInset)
        )
        
        leftVerticalStackView.frame = contentView.bounds
        leftVerticalStackView.axis = .vertical
        leftVerticalStackView.alignment = .leading
        leftVerticalStackView.distribution = .fillEqually
        leftVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        rightVerticalStackView.frame = contentView.bounds
        rightVerticalStackView.axis = .vertical
        rightVerticalStackView.alignment = .leading
        rightVerticalStackView.distribution = .fillEqually
        rightVerticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            rightVerticalStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            rightVerticalStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            rightVerticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: contentView.bounds.width * 0.5),
            rightVerticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -contentView.bounds.width * 0.05)
        ]
        
        let leftConstraints = [
            leftVerticalStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            leftVerticalStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            leftVerticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: contentView.bounds.width * 0.05),
            leftVerticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -contentView.bounds.width * 0.5)
        ]
        
        NSLayoutConstraint.activate(constraints)
        NSLayoutConstraint.activate(leftConstraints)
    }
    
    func configureCell(cellInfo: TaxiRideTableViewCellModel) {
        self.startAddress.text = cellInfo.startAddress
        self.endAddress.text = cellInfo.endAddress
        self.dateRide.text = cellInfo.dateRide
        self.costRide.text = cellInfo.costRide
    }
}
