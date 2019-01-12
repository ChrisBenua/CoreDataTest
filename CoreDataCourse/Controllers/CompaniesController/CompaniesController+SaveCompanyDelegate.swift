//
//  ViewController+SaveCompanyDelegate.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 11/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

///MARK:- SaveCompanyDelegate
extension CompaniesController : SaveCompanyDelegate {
    func companyUpdated(company : Company) {
        let index = companies.index(of: company)
        
        tableView.reloadRows(at: [IndexPath(item: index!, section: 0)], with: .middle)
    }
    
    
    
    func passCompany(comapany: Company) {
        companies.append(comapany)
        tableView.insertRows(at: [IndexPath(item: companies.count - 1, section: 0)], with: .automatic)
    }
    
    
}
