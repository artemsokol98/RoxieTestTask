//
//  MainViewModel.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 02.01.2023.
//

import Foundation

protocol MainViewModelProtocol {
    var taxiRide: Address { get set }
    var parsedTaxiRide: [TaxiRideTableViewCellModel] { get set }
    func fetchData(completion: @escaping (Result<Void, Error>) -> Void)
}

class MainViewModel: MainViewModelProtocol {
    var taxiRide: Address = [AddressElement]()
    
    var parsedTaxiRide = [TaxiRideTableViewCellModel]()
    
    
    func fetchData(completion: @escaping (Result<Void, Error>) -> Void) {
        NetworkManager.shared.downloadData { result in
            switch result {
            case .success(var address):
                DispatchQueue.main.async {
                    address.sort(by: {$0.orderTime.compare($1.orderTime) == .orderedDescending})
                    self.taxiRide = address
                    self.parsedTaxiRide = self.parseRidesForTableViewCell(inputData: address)
                    completion(.success(()))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    func parseRidesForTableViewCell(inputData: [AddressElement]) -> [TaxiRideTableViewCellModel] {
        var parsedTaxiRide = [TaxiRideTableViewCellModel]()
        for item in inputData {
            let dateRideWithoutTime = dateConverter(dateString: item.orderTime)
            let taxiRide = TaxiRideTableViewCellModel(
                startAddress: item.startAddress.address,
                endAddress: item.endAddress.address,
                dateRide: dateRideWithoutTime,
                costRide: "\(item.price.amount / 100),\(item.price.amount % 100)"+" "+"\(item.price.currency)"
            )
            parsedTaxiRide.append(taxiRide)
        }
        return parsedTaxiRide
    }
    
    func dateConverter(dateString: String) -> String {
        let dateFormatterISO8601 = ISO8601DateFormatter()
        let dateString = dateFormatterISO8601.date(from: dateString)! //.date(from: dateString)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .long
        let date = dateFormatter.string(from: dateString)
        return date
    }
    
}
