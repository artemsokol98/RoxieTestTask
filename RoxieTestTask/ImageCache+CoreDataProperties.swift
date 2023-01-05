//
//  ImageCache+CoreDataProperties.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 05.01.2023.
//
//

import Foundation
import CoreData


extension ImageCache {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ImageCache> {
        return NSFetchRequest<ImageCache>(entityName: "ImageCache")
    }

    @NSManaged public var date: Double
    @NSManaged public var id: String?
    @NSManaged public var image: Data?

}

extension ImageCache : Identifiable {

}
