//
//  Company.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 31/12/2018.
//  Copyright © 2018 Christian Benua. All rights reserved.
//

import Foundation

struct Company {
    let name : String
    let founded : Date
    let photo : Data
    let employees : [Employee]
}

struct Employee {
    let name : String
    let birthday : Date
    let type : String
    let company : Company
}
