//
//  DetailViewModel.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 03.01.2023.
//

import Foundation
import UIKit

protocol DetailViewModelProtocol {
    var customElements: [CustomElementModel] { get set }
}

class DetailViewModel: DetailViewModelProtocol {
    var customElements: [CustomElementModel] = [PhotoElement(image: nil, apiString: nil), NameElement(nameDriver: nil)]
    
    
    
}

enum CustomElementType: String {
    case photo
    case nameDriver
    case car
}

enum CustomHeightRow: CGFloat {
    case photo = 300.0
    case nameDriver = 100.0
}



protocol CustomElementModel: AnyObject {
    var type: CustomElementType { get }
    var heightRow: CustomHeightRow { get }
}

protocol CustomElementCell: AnyObject {
    static var identifier: String { get }
    func configure(withModel: CustomElementModel)
}


class PhotoElement: CustomElementModel {
    var heightRow: CustomHeightRow { return .photo }
    
    var type: CustomElementType { return .photo }
    var image: Data?
    var apiString: String?
    
    init(image: Data?, apiString: String?) {
        self.image = image
        self.apiString = apiString
    }
}

class PhotoElementCell: UITableViewCell, CustomElementCell {
    
    static var identifier = "PhotoElement"
    
    var model: PhotoElement!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? PhotoElement else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
        if let unwrappedImage = model.image {
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

class NameElement: CustomElementModel {
    var heightRow: CustomHeightRow { return .nameDriver }
    
    var type: CustomElementType { return .nameDriver }
    var name: String?
    
    init(nameDriver: String?) {
        self.name = nameDriver
    }
}

class NameElementCell: UITableViewCell, CustomElementCell {
    static var identifier = "NameElementCell"
    
    var model: NameElement!
    
    func configure(withModel elementModel: CustomElementModel) {
        guard let model = elementModel as? NameElement else {
            print("Unable to cast model as ProfileElement: \(elementModel)")
            return
        }
        self.model = model
        
        configureUI()
    }
    
    func configureUI() {
        nameLabel.text = model.name
    }
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
    }
}
