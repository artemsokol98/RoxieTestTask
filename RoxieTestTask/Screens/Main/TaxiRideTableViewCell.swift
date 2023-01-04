//
//  TaxiRideTableViewCell.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 02.01.2023.
//

import UIKit

class TaxiRideTableViewCell: UITableViewCell {
    
    static let identifier = "TaxiRideIdentifier"
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.addArrangedSubview(startAddress)
        stackView.addArrangedSubview(endAddress)
        stackView.addArrangedSubview(dateRide)
        stackView.addArrangedSubview(costRide)
        return stackView
    }()
    
    private lazy var startAddress: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var endAddress: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var dateRide: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private lazy var costRide: UILabel = {
        let label = UILabel()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(verticalStackView)
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        verticalStackView.frame = contentView.bounds
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .center
        verticalStackView.distribution = .fillEqually
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let constraints = [
            verticalStackView.topAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    func configureCell(cellInfo: TaxiRideTableViewCellModel) {
        self.startAddress.text = cellInfo.startAddress
        self.endAddress.text = cellInfo.endAddress
        self.dateRide.text = cellInfo.dateRide
        self.costRide.text = cellInfo.costRide
    }
    
/*
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
*/
}
