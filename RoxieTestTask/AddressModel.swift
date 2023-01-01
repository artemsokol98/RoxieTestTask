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
    let orderTime: Date
    let vehicle: Vehicle
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
