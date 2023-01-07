//
//  DetailViewModel.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 03.01.2023.
//

import Foundation
import UIKit

struct CollectionViewCellModel {
    let label: String
}

protocol DetailViewModelProtocol {
    var customElements: [CustomElementModel] { get set }
    func parseForCollectionView(data: AddressElement) -> [String]
}

class DetailViewModel: DetailViewModelProtocol {
    var customElements: [CustomElementModel] = [PhotoElement(image: nil, apiString: nil), NameElement(nameDriver: nil, arrayOfCells: nil)]
    
    func parseForCollectionView(data: AddressElement) -> [String] {
        var arrayOfCells = [String]()
        arrayOfCells.append(data.startAddress.address)
        arrayOfCells.append(data.endAddress.address)
        arrayOfCells.append(data.vehicle.modelName)
        arrayOfCells.append(data.vehicle.driverName)
        arrayOfCells.append(data.vehicle.regNumber)
        arrayOfCells.append(dateConverter(dateString: data.orderTime))
//        arrayOfCells.append(data.startAddress.address)
//        arrayOfCells.append(data.endAddress.address)
        return arrayOfCells
    }
    
    func dateConverter(dateString: String) -> String {
        let dateFormatterISO8601 = ISO8601DateFormatter()
        let dateString = dateFormatterISO8601.date(from: dateString)!
        let dateFormatter = DateFormatter()
        //dateFormatter.timeStyle = .short
        dateFormatter.dateFormat = "d MMM yyyy HH:mm"//"HH:mm"
        
        
        //dateFormatter.dateStyle = .
        //dateFormatter.timeZone = .none
        let date = dateFormatter.string(from: dateString)
        return date
    }
    
    
}

enum CustomElementType: String {
    case photo
    case nameDriver
    case car
}

enum CustomHeightRow: CGFloat {
    case photo = 300.0
    case nameDriver = 700.0
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
    var arrayForCells: [String]?
    
    init(nameDriver: String?, arrayOfCells: [String]?) {
        self.name = nameDriver
        self.arrayForCells = arrayOfCells
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
        //nameLabel.text = model.name
        collectionView.reloadData()
    }
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.register(DetailInfoCollectionViewCell.self, forCellWithReuseIdentifier: DetailInfoCollectionViewCell.identifier)
        return collectionView
    }()
    /*
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    */
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //contentView.addSubview(nameLabel)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        /*
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let labelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
         */
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionViewConstraints = [
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ]
        
        NSLayoutConstraint.activate(collectionViewConstraints)
    }

}

// MARK: - Collection View

extension NameElementCell: UICollectionViewDelegate {
    
}

extension NameElementCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        model.arrayForCells?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DetailInfoCollectionViewCell.identifier, for: indexPath) as? DetailInfoCollectionViewCell else { print("error in collectionView cell"); return UICollectionViewCell() }
        cell.configureCell(string: (model.arrayForCells?[indexPath.item])!)
        return cell
    }
    
    
}

extension NameElementCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = contentView.frame.size.width * 0.4
        return CGSize(width: width, height: width)
    }
}
