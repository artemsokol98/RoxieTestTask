//
//  GenericModelForTableViewCell.swift
//  RoxieTestTask
//
//  Created by Артем Соколовский on 09.01.2023.
//

import Foundation

enum CustomElementType: String {
    case photo
    case nameDriver
    case car
}




protocol CustomElementModel: AnyObject {
    var type: CustomElementType { get }
}

protocol CustomElementCell: AnyObject {
    static var identifier: String { get }
    func configure(withModel: CustomElementModel?)
}


class PhotoElement: CustomElementModel {
    var type: CustomElementType { return .photo }
    var image: Data?
    var apiString: String?
    
    init(image: Data?, apiString: String?) {
        self.image = image
        self.apiString = apiString
    }
}

class NameElement: CustomElementModel {
    var type: CustomElementType { return .nameDriver }
    var name: String?
    var arrayForCells: [CollectionViewCellModel]?
    
    init(nameDriver: String?, arrayOfCells: [CollectionViewCellModel]?) {
        self.name = nameDriver
        self.arrayForCells = arrayOfCells
    }
}
