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
        sessionConfig.timeoutIntervalForRequest = 30
        let session = URLSession(configuration: sessionConfig)
        guard let url = URL(string: stringApi) else { return }
        
        session.dataTask(with: url) { data, response, error in
            if let data = data, error == nil {
                print(data)
                if let decodedData = try? JSONDecoder().decode(Address.self, from: data) {
                    print(decodedData)
                    completion(.success(decodedData))
                }
            } else {
                guard let error = error else { return }
                print(error)
                completion(.failure(error))
            }
        }.resume()
    }
    
    func fetchImage(urlString: String) -> UIImage {
        guard let url = URL(string: urlString) else { return UIImage() }
        guard let imageData = try? Data(contentsOf: url) else { return UIImage() }
        return UIImage(data: imageData)!; #warning("remove force unwrapping")
    }
}
