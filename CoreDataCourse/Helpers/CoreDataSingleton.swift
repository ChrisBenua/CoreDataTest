//
//  CoreDataSingleton.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 08/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class CoreDataManager {
    public static let shared = CoreDataManager()
    
    let persistantContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CompanyEmployeeModels")
        container.loadPersistentStores { (desc, err) in
            if let err = err {
                print("Error in loading Core Data", err)
            }
        }
        return container
    }()
    
    var context : NSManagedObjectContext {
        get {
            return persistantContainer.viewContext
        }
    }
}
