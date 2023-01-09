//
//  DetailViewModel.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 03.01.2023.
//

import UIKit

protocol DetailViewModelProtocol {
    var customElements: [CustomElementModel] { get set }
    var data: AddressElement? { get set }
    var image: Data? { get set }
    func parseForCollectionView(data: AddressElement) -> [CollectionViewCellModel]
    func downloadImage(completion: @escaping (Result<Void,Error>) -> Void)
}

class DetailViewModel: DetailViewModelProtocol {
    var customElements: [CustomElementModel] = [PhotoElement(image: nil, apiString: nil), NameElement(nameDriver: nil, arrayOfCells: nil)]
    var data: AddressElement?
    var image: Data?
    
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
    
    func downloadImage(completion: @escaping (Result<Void,Error>) -> Void) {
        guard let numberOfPhoto = data?.vehicle.photo else { return }
        DataManager.shared.getImage(urlString: "https://www.roxiemobile.ru/careers/test/images/" + numberOfPhoto) { image in
            switch image {
            case .success(let image):
                guard let image = image else {
                    return
                }
                self.image = image
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
