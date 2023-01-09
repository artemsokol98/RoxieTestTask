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
        guard let dateString = dateFormatterISO8601.date(from: dateString) else { return "2023" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM yyyy HH:mm"
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
    func configure(withModel: CustomElementModel?)
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

