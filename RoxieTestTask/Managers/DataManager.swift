//
//  DataManager.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 04.01.2023.
//

import UIKit
import CoreData

class DataManager {
    static let shared = DataManager()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    
    func createNewItemImage(apiString: String, image: Data?) {
        let newItem = ImageCache(context: context)
        newItem.image = image
        newItem.id = apiString
        newItem.date = Date().timeIntervalSinceReferenceDate 
        do {
            try context.save()
        } catch {
            
        }
    }
    
    func necessetyOfCaching(data: ImageCache) -> Bool {
        let currentTime = Date().timeIntervalSinceReferenceDate
        return currentTime - data.date < 600.0 ? true : false
    }
    
    func fetchDataFromCache(urlString: String) throws -> Data? {
        let request = ImageCache.fetchRequest() as NSFetchRequest<ImageCache>
        request.predicate = NSPredicate(format: "id == %@", urlString)
        guard let data = try? context.fetch(request) else {
            throw CoreDataErrors.CouldntFetchFromEntity
        
        }
        guard let dataForCheck = data.first else { return nil }
        if necessetyOfCaching(data: dataForCheck) {
            return data.first?.image
        } else {
            return nil
        }
        
    }
    
    
    func getImage(urlString: String, completion: @escaping (Result<Data?,Error>) -> Void) {
        var image: Data?
        do {
            image = try? fetchDataFromCache(urlString: urlString)
            if image == nil { throw CoreDataErrors.CouldntFetchFromEntity }
            completion(.success(image))
        } catch {
            NetworkManager.shared.downloadData(urlString: urlString, expectingType: Data.self) { result in
                switch result {
                case .success(let data):
                    guard let data = data as? Data else { return }
                    image = data
                    self.createNewItemImage(apiString: urlString, image: image)
                    completion(.success(image))
                case .failure(let error):
                    print(error)
                    completion(.failure(error))
                }
            }
        }
    }
}

enum CoreDataErrors: Error {
    case CouldntFetchFromEntity
}
