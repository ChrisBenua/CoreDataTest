//
//  APIHelper.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 18/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import CoreData

class APIHelper {
    
    public static let shared = APIHelper()
    
    let urlString = "https://api.letsbuildthatapp.com/intermediate_training/companies"
        
    public func fetchCompaniesFromServer() {
        URLSession.shared.dataTask(with: URL(string: urlString)!) { (data, resp, err) in
            if let err = err {
                print("Error while loading companies", err)
            }
            print(String(data: data!, encoding: .utf8))
            guard let data = data else { return }
            
            do {
                let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
                privateContext.parent = CoreDataManager.shared.context
                let jsonCompanies = try JSONDecoder().decode([JSONCompany].self, from: data)
                jsonCompanies.forEach({ (comp) in
                    comp.JSON2CoreData(privateContext : privateContext)
                })
                
                do {
                    try privateContext.save()
                    try privateContext.parent?.save()
                } catch let err {
                    print("Error while saving private context", err)
                }
            } catch let err {
                print("Error while decoding companies from JSON server response", err)
            }
            
        }.resume()
    }
}
