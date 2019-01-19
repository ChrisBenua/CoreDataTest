//
//  Company.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 31/12/2018.
//  Copyright © 2018 Christian Benua. All rights reserved.
//

import Foundation
import CoreData


/*struct Company {
    var name : String
    var founded : Date
    var photo : Data
    var employees : [Employee]
}*/

/*class Employee {
    var name : String
    var birthday : Date
    var type : String
    var company : Company
    
    init(name : String, bithday : Date, type : String, company : Company) {
        self.name = name
        self.birthday = bithday
        self.type = type
        self.company = company
    }
}*/


struct JSONCompany : Decodable {
    let name : String
    
    let founded : String
    
    let photoUrl : String
    
    var employees : [JSONEmployee]?
    
    public func JSON2CoreData(privateContext : NSManagedObjectContext) {
        let company = Company(context: privateContext)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        company.name = name
        company.founded = dateFormatter.date(from: founded) ?? Date()
        
        /*Data.download(urlString: photoUrl, completionHandler: { (data) in
            company.photo = data
        })*/
        company.photo = Data()
        
        employees?.forEach({ (empl) in
            let employee = Employee(context: privateContext)
            
            employee.fullName = empl.name
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            
            employee.birthday = dateFormatter.date(from: empl.birthday) ?? Date()
            
            employee.type = empl.type
            employee.company = company
        })
        
        print("Name : ", company.name)
        print("Date : ", company.founded?.description)
        print("Empl : ", company.employees?.count)
        
        //company.founded =
    }
}

struct JSONEmployee : Decodable {
    let name : String
    
    let birthday : String
    
    let type : String
    
    public func JSON2Employee(company : Company) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = CoreDataManager.shared.context
        let employee = Employee(context: privateContext)
        
        employee.fullName = name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        employee.birthday = dateFormatter.date(from: birthday)
        
        employee.type = type
        employee.company = company
        
        do {
            try privateContext.save()
            try privateContext.parent?.save()
        } catch let err {
            print("Error while converting JSONEmployee to CoreData Employee", err)
        }
    }
}
