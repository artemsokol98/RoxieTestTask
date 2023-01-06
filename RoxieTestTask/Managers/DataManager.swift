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
        newItem.image = image // here need imageData instead UIImage
        newItem.id = apiString
        newItem.date = Date().timeIntervalSinceReferenceDate //double
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
    
    
    func getImage(urlString: String) -> Data? {
        var image: Data?
        do {
            image = try? fetchDataFromCache(urlString: urlString)
            if image == nil { throw CoreDataErrors.CouldntFetchFromEntity } //CoreDataErrors.CouldntFetchFromEntity
        } catch {
            DispatchQueue.main.async {
                NetworkManager.shared.fetchImageAsync(urlString: urlString) { result in
                    switch result {
                    case .success(let data):
                        image = data
                        self.createNewItemImage(apiString: urlString, image: image)
                    case .failure(let error):
                        print(error)
                    }
                }//fetchImage(urlString: urlString)
            }
        }
        return image
    }
}

enum CoreDataErrors: Error {
    case CouldntFetchFromEntity
}
