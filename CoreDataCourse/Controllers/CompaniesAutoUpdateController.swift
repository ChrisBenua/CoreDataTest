//
//  CompaniesAutoUpdateController.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 17/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CompaniesAutoUpdateController : UITableViewController {
    
    lazy var fetchedResultsController : NSFetchedResultsController<Company> = {
        let request : NSFetchRequest<Company> = Company.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: CoreDataManager.shared.context, sectionNameKeyPath: "name", cacheName: nil)
        frc.delegate = self
        do {
            try frc.performFetch()
        } catch let err {
            print("error in NSFetchResultsController", err)
        }
        return frc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "CompanyAutoUpdates"
        view.backgroundColor = UIColor.mainBackgroundColor()
        tableView.register(CompanyTableViewCell.self, forCellReuseIdentifier: "id")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Update", style: .plain, target: self, action: #selector(handleUpdate))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Delete", style: .plain, target: self, action: #selector(handleDelete))
        
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .white
        self.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(toggleRefresh), for: .valueChanged)
    }
    
    @objc func toggleRefresh() {
        APIHelper.shared.fetchCompaniesFromServer()
    }
    
    @objc func handleDelete() {
        print("Deleting some Companies")
        
        let request : NSFetchRequest<Company> = Company.fetchRequest()
        //request.predicate = NSPredicate(format: "name CONTAINS %@", "B")
        let context = CoreDataManager.shared.persistantContainer.viewContext
        var companiesStartsWithB : [Company] = [Company]()
        do {
            companiesStartsWithB = try context.fetch(request)
        } catch let err {
            print("Error while fetching companies in handleDelete", err)
        }
        companiesStartsWithB.forEach({ (company) in
            context.delete(company)
        })
        
        do {
            try context.save()
        } catch let err {
            print("Error while saving context", err)
        }
    }
    
    @objc func handleUpdate() {
        let company = Company(context: CoreDataManager.shared.context)
        company.name = "New Name 2"
        company.photo = Data()
        company.founded = Date()
        do {
            try CoreDataManager.shared.context.save()
        } catch let err {
            print("Error in handle Updating", err)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections![section].numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label : PaddingLabel = PaddingLabel(padding: UIEdgeInsets(top: 5, left: 16, bottom: 5, right: 0))
        label.text = fetchedResultsController.sectionIndexTitles[section]
        label.backgroundColor = UIColor.mainLightBlue
        return label
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! CompanyTableViewCell
        cell.company = fetchedResultsController.object(at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EmployeesController()
        vc.company = fetchedResultsController.object(at: indexPath)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CompaniesAutoUpdateController : NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        case .move:
            break
        case .update:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .middle)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        self.refreshControl?.endRefreshing()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return sectionName
    }
}
