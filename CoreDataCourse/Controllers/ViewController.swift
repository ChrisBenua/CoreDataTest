//
//  ViewController.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 31/12/2018.
//  Copyright © 2018 Christian Benua. All rights reserved.
//

import UIKit

class CompaniesController: UITableViewController {

    var companies = [Company(name: "Apple", founded : Date(), photo : Data(), employees : []), Company(name: "Google", founded: Date(), photo: Data(), employees: [])]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationController?.navigationBar.barTintColor = .red
        navigationItem.title = "Companies"
        navigationController?.navigationBar.prefersLargeTitles = true

        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "plus").withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(plusButtonPressed))]
        
        view.backgroundColor = UIColor.mainBackgroundColor()
        
        tableView.register(CompanyTableViewCell.self, forCellReuseIdentifier: "id")
        
        tableView.tableFooterView = UIView()
    }
    
    @objc func plusButtonPressed() {
        print("Button pressed")
        
        let vc = AddCompanyController()
        vc.delegate = self
        let navc = CustomNavigationController(rootViewController: vc)
        
        present(navc, animated: true, completion: nil)
    }
}

//MARK:- Headers
extension CompaniesController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .mainLightBlue
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}

//MARK:- TableViewController Delegates
extension CompaniesController {

     override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! CompanyTableViewCell
        cell.company = companies[indexPath.row]
        return cell
    }
}


extension CompaniesController : SaveCompanyDelegate {
    func passCompany(comapany: Company) {
        companies.append(comapany)
        tableView.insertRows(at: [IndexPath(item: companies.count - 1, section: 0)], with: .automatic)
    }
    
    
}
