//
//  AddressModel.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 01.01.2023.
//

import Foundation

// MARK: - AddressElement
struct AddressElement: Codable {
    let id: Int
    let startAddress, endAddress: EndAddressClass
    let price: Price
    let orderTime: String
    let vehicle: Vehicle
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        //print(container)
        id = try container.decode(Int.self, forKey: .id)
        print(id)
        startAddress = try container.decode(EndAddressClass.self, forKey: .startAddress)
        print(startAddress)
        endAddress = try container.decode(EndAddressClass.self, forKey: .endAddress)
        print(endAddress)
        price = try container.decode(Price.self, forKey: .price)
        print(price)
        orderTime = try container.decode(String.self, forKey: .orderTime)
        print(orderTime)
        vehicle = try container.decode(Vehicle.self, forKey: .vehicle)
        print(vehicle)
    }
    
    enum CodingKeys: String, CodingKey {
        case id, startAddress, endAddress, price, orderTime, vehicle
    }
}

// MARK: - EndAddressClass
struct EndAddressClass: Codable {
    let city, address: String
}

// MARK: - Price
struct Price: Codable {
    let amount: Int
    let currency: String
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let regNumber, modelName, photo, driverName: String
}

typealias Address = [AddressElement]
