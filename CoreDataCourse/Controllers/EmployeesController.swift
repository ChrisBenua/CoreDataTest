//
//  EmployeesController.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 11/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


class EmployeesController : UITableViewController {
    
    var employees : [Employee]! {
        didSet {
            tableView.reloadData()
        }
    }
    
    var company : Company? {
        didSet {
           navigationItem.title = company?.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(handleAddEmployee))
    }
    
    @objc func handleAddEmployee() {
        print("Adding Employee")
        let vc = CreateEmployeeController()
        let nav = CustomNavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
    }
}
///MARK:- UITAbleView DataSource
extension EmployeesController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
   
}

///MARK:- Headers
extension EmployeesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var sectionHeadersNames : [String] = ["Executive", "Senior Manager", "Staff"]
        
        let header = UIView()
        header.backgroundColor = UIColor.mainLightBlue
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = sectionHeadersNames[section]
        label.textAlignment = .left
        header.addSubview(label)
        label.anchor(top: header.topAnchor, left: header.leftAnchor, bottom: header.bottomAnchor, right: header.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
