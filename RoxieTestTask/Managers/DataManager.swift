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
    
    
}
