//
//  DetailViewModel.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 03.01.2023.
//

import Foundation
import UIKit

struct CollectionViewCellModel {
    let nameOfCell: String
    let infoLabel: String
}

protocol DetailViewModelProtocol {
    var customElements: [CustomElementModel] { get set }
    func parseForCollectionView(data: AddressElement) -> [CollectionViewCellModel]
}

class DetailViewModel: DetailViewModelProtocol {
    var customElements: [CustomElementModel] = [PhotoElement(image: nil, apiString: nil), NameElement(nameDriver: nil, arrayOfCells: nil)]
    
    func parseForCollectionView(data: AddressElement) -> [CollectionViewCellModel] {
        var arrayOfCells = [CollectionViewCellModel]()
        arrayOfCells.append(
            CollectionViewCellModel(
                nameOfCell: "Начальный адрес",
                infoLabel: data.startAddress.address)
        )
        arrayOfCells.append(
            CollectionViewCellModel(
                nameOfCell: "Конечный адрес",
                infoLabel: data.endAddress.address)
        )
        arrayOfCells.append(
            CollectionViewCellModel(
                nameOfCell: "Модель машины",
                infoLabel: data.vehicle.modelName)
        )
        arrayOfCells.append(
            CollectionViewCellModel(
                nameOfCell: "Имя водителя",
                infoLabel: data.vehicle.driverName)
        )
        arrayOfCells.append(
            CollectionViewCellModel(
                nameOfCell: "Номер машины",
                infoLabel: data.vehicle.regNumber)
        )
        arrayOfCells.append(
            CollectionViewCellModel(
                nameOfCell: "Время поездки",
                infoLabel: dateConverter(dateString: data.orderTime))
        )
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




protocol CustomElementModel: AnyObject {
    var type: CustomElementType { get }
}

protocol CustomElementCell: AnyObject {
    static var identifier: String { get }
    func configure(withModel: CustomElementModel)
}


class PhotoElement: CustomElementModel {
    var type: CustomElementType { return .photo }
    var image: Data?
    var apiString: String?
    
    init(image: Data?, apiString: String?) {
        self.image = image
        self.apiString = apiString
    }
}

class NameElement: CustomElementModel {
    var type: CustomElementType { return .nameDriver }
    var name: String?
    var arrayForCells: [CollectionViewCellModel]?
    
    init(nameDriver: String?, arrayOfCells: [CollectionViewCellModel]?) {
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
        collectionView.reloadData()
    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        let collectionView = UICollectionView(frame: .infinite, collectionViewLayout: layout)
        collectionView.register(DetailInfoCollectionViewCell.self, forCellWithReuseIdentifier: DetailInfoCollectionViewCell.identifier)
        return collectionView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

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
        cell.configureCell(model: (model.arrayForCells?[indexPath.item])!)
        return cell
    }
}

extension NameElementCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width: CGFloat = contentView.frame.size.width * 0.42
        let height: CGFloat = contentView.frame.size.width * 0.3
        return CGSize(width: width, height: height)
    }
}
