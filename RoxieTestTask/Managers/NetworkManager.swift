//
//  NetworkManager.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 01.01.2023.
//

import Foundation
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    
    let stringApi = "https://www.roxiemobile.ru/careers/test/orders.json"
    
    let sessionConfig = URLSessionConfiguration.default
    
    func downloadData(completion: @escaping (Result<Address,Error>) -> Void) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: stringApi) else { return }
        
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                if let decodedData = try? JSONDecoder().decode(Address.self, from: data) {
                    completion(.success(decodedData))
                }
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImageAsync(urlString: String, completion: @escaping (Result<Data,Error>) -> Void) {
        sessionConfig.timeoutIntervalForRequest = 10
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: urlString) else { return }
        
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                completion(.success(data))
            } else {
                guard let error = error else { return }
                completion(.failure(error))
            }
        }.resume()
    }
}
