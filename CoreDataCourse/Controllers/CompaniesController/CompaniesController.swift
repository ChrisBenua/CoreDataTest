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
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain, target: self, action: #selector(handleReset))
        
        view.backgroundColor = UIColor.mainBackgroundColor()
        
        tableView.register(CompanyTableViewCell.self, forCellReuseIdentifier: "id")
        
        tableView.tableFooterView = UIView()
        
        fetchComapnies()
        
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




