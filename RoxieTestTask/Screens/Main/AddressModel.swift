//
//  AddressModel.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 01.01.2023.
//

import Foundation

// MARK: - AddressElement
struct AddressElement: Decodable {
    let id: Int
    let startAddress, endAddress: EndAddressClass
    let price: Price
    let orderTime: String
    let vehicle: Vehicle
}

// MARK: - EndAddressClass
struct EndAddressClass: Decodable {
    let city, address: String
}

// MARK: - Price
struct Price: Decodable {
    let amount: Int
    let currency: String
}

// MARK: - Vehicle
struct Vehicle: Decodable {
    let regNumber, modelName, photo, driverName: String
}

typealias Address = [AddressElement]
