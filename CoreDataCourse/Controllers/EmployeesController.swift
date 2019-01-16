//
//  EmployeesController.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 11/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class EmployeesController : UITableViewController {
    
    var allEmployees : [Employee]!
    var secHeaders = EmployeeType.allCases.map({$0.rawValue})
    var splittedEmployees = [[Employee]]()
    
    var company : Company? {
        didSet {
           navigationItem.title = company?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "id")
        fetchEmployees()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddEmployee))
        let footer = UIView()
        footer.backgroundColor = UIColor.mainBackgroundColor()
        tableView.tableFooterView = footer
    }
    
    @objc func handleAddEmployee() {
        print("Adding Employee")
        let vc = CreateEmployeeController()
        vc.delegate = self
        vc.company = self.company
        let nav = CustomNavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}

///MARK:- COreData
extension EmployeesController {
    func fetchEmployees() {
        guard let empl = company?.employees?.allObjects as? [Employee] else { return }

        self.allEmployees = empl
        splittedEmployees.removeAll()
        for name in secHeaders {
            splittedEmployees.append(allEmployees.filter({ (emp) -> Bool in
                guard let type = emp.type else { return false }
                return type == name
            }))
        }
    }
}

///MARK:- UITAbleView DataSource
extension EmployeesController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return splittedEmployees.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return splittedEmployees[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd, yyyy"
        var dateText = ""
        let employee = splittedEmployees[indexPath.section][indexPath.row]
        if (employee.birthday != nil) {
            dateText = dateFormatter.string(from: employee.birthday!)
        }
        cell.textLabel?.text = employee.name! + "    " + dateText
        cell.backgroundColor = UIColor.mainCellBackgroundColor()
        return cell
    }
   
}

///MARK:- Headers
extension EmployeesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let header = UIView()
        header.backgroundColor = UIColor.mainLightBlue
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = secHeaders[section]
        label.textAlignment = .left
        header.addSubview(label)
        label.anchor(top: header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, paddingTop: 0, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

///MARK:- CreateEmployeeDelegate
extension EmployeesController : CreateEmployeeDelegate {
    func passNewEmployee(employee: Employee) {
        EmployeeType.allCases.filter { (type) -> Bool in
            employee.type == type.rawValue
            }.forEach { (type) in
                guard let ind = secHeaders.index(of: type.rawValue) else { return }
                splittedEmployees[ind].append(employee)
                tableView.insertRows(at: [IndexPath(row: splittedEmployees[ind].count-1, section: ind)], with: .middle)
        }
    }
    
    
}
