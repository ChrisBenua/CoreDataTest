//
//  ViewController+TableViewDelegates.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 11/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

///MARK:- TableViewDelegate
extension CompaniesController {
    
    private func deleteActionHandler(action : UITableViewRowAction, indexPath : IndexPath) {
        let company = self.companies[indexPath.row]
        self.companies.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        let context = CoreDataManager.shared.context
        context.delete(company)
        do {
            try context.save()
        } catch let err {
            print("Error while saving context after delete action\n", err)
        }
    }
    
    private func editActionHandler(action : UITableViewRowAction, indexPath : IndexPath) {
        var company = self.companies[indexPath.row]
        
        let editController = AddCompanyController()
        editController.editedCompany = company
        editController.delegate = self
        let nav = CustomNavigationController(rootViewController : editController)
        
        present(nav, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete", handler: deleteActionHandler)
        
        let editAction = UITableViewRowAction(style: .normal, title: "Edit", handler: editActionHandler)
        
        return [deleteAction, editAction]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = EmployeesController()
        
        vc.company = companies[indexPath.row]
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
