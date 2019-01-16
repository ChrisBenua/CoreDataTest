//
//  ViewController.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 31/12/2018.
//  Copyright © 2018 Christian Benua. All rights reserved.
//

import UIKit
import CoreData


class CompaniesController: UITableViewController {

    var companies = [Company]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //navigationController?.navigationBar.barTintColor = .red
        navigationItem.title = "Companies"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(plusButtonPressed))]
        
        navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset)), UIBarButtonItem(title: "Do Work", style: .plain, target: self, action: #selector(doNestedUpdates))]//delete second one
        
        view.backgroundColor = UIColor.mainBackgroundColor()
        
        tableView.register(CompanyTableViewCell.self, forCellReuseIdentifier: "id")
        
        tableView.tableFooterView = UIView()
        
        fetchComapnies()
        
    }
    
    @objc private func doWork() {
        CoreDataManager.shared.persistantContainer.performBackgroundTask { (backgroundContext) in
            (0...5).forEach({ (value) in
                print(value)
                let company = Company(context: backgroundContext)
                company.name = String(value)
                company.employees = NSSet(array: [Employee]())
                company.photo = Data()
                company.founded = Date()
            })
            do {
                try backgroundContext.save()
                
                DispatchQueue.main.async {
                    self.companies = CoreDataManager.shared.fetchCompanies()
                    self.tableView.reloadData()
                }
            } catch let err {
                print("Error while creating company", err)
            }
        }
        
    }
    
    @objc private func doUpdates() {
        
        
        CoreDataManager.shared.persistantContainer.performBackgroundTask { (backgroundContext) in
            let fetchRequest : NSFetchRequest<Company> = Company.fetchRequest()
            do {
                let companies = try backgroundContext.fetch(fetchRequest)
                companies.forEach({ (comp) in
                    print(comp.name ?? "")
                    comp.name = "A: \(comp.name)"
                })
                do {
                    try backgroundContext.save()
                    
                    DispatchQueue.main.async {
                        self.companies = CoreDataManager.shared.fetchCompanies()
                        self.tableView.reloadData()
                    }
                } catch let err {
                    print("Failed to save on background", err)
                }
            } catch let err {
                print("Error while updating companies on background thread", err)
            }
        }
    }
    
    @objc private func doNestedUpdates() {
        DispatchQueue.global(qos: .background).async {
            //Custom context
            
            let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            privateContext.parent = CoreDataManager.shared.context
            
            let request : NSFetchRequest = Company.fetchRequest()
            request.fetchLimit = 1
            do {
                let privateCompanies = try privateContext.fetch(request)
                privateCompanies.forEach({ (comp) in
                    print(comp.name ?? "")
                    comp.name = "Kek: \(comp.name ?? "")"
                })
                do {
                    try privateContext.save()
                    
                    DispatchQueue.main.async {
                        do {
                            try CoreDataManager.shared.context.save()
                            self.tableView.reloadData()
                        } catch let err {
                            print("Parent error while saving parent context", err)
                        }
                    }
                } catch let err {
                    print("Error while saving privateContext", err)
                }
            } catch let err {
                print("Fetch error in private context", err)
            }
        }
    }
    
    @objc private func handleReset() {
        print("Reset")
        
        tableView.deleteRows(at: CoreDataManager.shared.resetCompanies(companies: &self.companies).map({ (ind) -> IndexPath in
            IndexPath(row: ind, section: 0)
        }), with: .left)
        
    }
    
    
    private func fetchComapnies() {
        //core data fetch
        self.companies = CoreDataManager.shared.fetchCompanies()
        self.tableView.reloadData()
    }
    
    @objc func plusButtonPressed() {
        print("Button pressed")
        
        let vc = AddCompanyController()
        vc.delegate = self
        let navc = CustomNavigationController(rootViewController: vc)
        
        present(navc, animated: true, completion: nil)
    }
}




