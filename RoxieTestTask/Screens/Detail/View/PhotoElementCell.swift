//
//  PhotoElementCell.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 08.01.2023.
//

import UIKit

class PhotoElementCell: UITableViewCell, CustomElementCell {
    
    static var identifier = "PhotoElement"
    
    var model: PhotoElement?
    
    func configure(withModel elementModel: CustomElementModel?) {
        guard let model = elementModel as? PhotoElement else {
            return
        }
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
        if let unwrappedImage = model?.image {
            carImage.image = UIImage(data: unwrappedImage)
        }
    }

    lazy var carImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(carImage)
        
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
        carImage.layer.cornerRadius = contentView.bounds.width * Constants.carImagePhotoElementCornerRadiusMultiplier
        carImage.translatesAutoresizingMaskIntoConstraints = false
        
        let carImageConstraints = [
            carImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            carImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            carImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            carImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(carImageConstraints)
    }
}
