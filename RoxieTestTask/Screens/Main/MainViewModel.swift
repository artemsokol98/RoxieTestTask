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
            case .success(let address):
                DispatchQueue.main.async {
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
            let taxiRide = TaxiRideTableViewCellModel(
                startAddress: item.startAddress.address,
                endAddress: item.endAddress.address,
                dateRide: item.orderTime,
                costRide: item.price.currency
            )
            parsedTaxiRide.append(taxiRide)
        }
        return parsedTaxiRide
    }
}
