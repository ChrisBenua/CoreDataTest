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
    
    public func fetchCompanies() -> [Company] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Company")
        do {
            
            let companies = try context.fetch(fetchRequest) as! [Company]
            return companies
            
        } catch let err {
            print("Failed to fetch companies", err)
            return []
        }
    }
    
    public func resetCompanies(companies : inout [Company]) -> Range<Int> {
        let request : NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Company.fetchRequest())
        do {
            try context.execute(request)
            let indices = companies.indices
            companies.removeAll()
            return indices
           
        } catch let err {
            print("Failed to batch delete object from core data, error: \n", err)
            return [].indices
        }
    }
}
