//
//  CreateEmployee.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 11/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

protocol CreateEmployeeDelegate : class {
    func passNewEmployee(employee : Employee);
}

class CreateEmployeeController : UIViewController {
    
    var company : Company?
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let BirthdayLabel : UILabel = {
       let label = UILabel()
        label.text = "Birthday"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    let nameTextField : UITextField = {
       let tf = UITextField()
        tf.placeholder = "Enter Employee's Name"
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let BirthdayTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = "MM/DD/YYYY"
        tf.font = UIFont.systemFont(ofSize: 18)
        return tf
    }()
    
    let segmentControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: EmployeeType.allCases.map{ $0.rawValue })
        
        
        
        sc.tintColor = UIColor.init(white: 0, alpha: 0.7)
        sc.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16)], for: .normal)
        sc.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor : UIColor.lightText], for: .selected)
        sc.tintColor = UIColor.mainBackgroundColor()
        sc.selectedSegmentIndex = 0
        return sc
    }()
    
    let containerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.mainLightBlue
        return view
    }()
    
    weak var delegate : CreateEmployeeDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(containerView)
        
        navigationItem.title = "Create Employee"
        
        navigationController?.navigationBar.isTranslucent = false
        
        containerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        containerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3).isActive = true
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        nameStackView.distribution = .fillProportionally
        nameLabel.widthAnchor.constraint(equalTo: nameStackView.widthAnchor, multiplier: 0.3).isActive = true
        let birthdayStackView = UIStackView(arrangedSubviews: [BirthdayLabel, BirthdayTextField])
        BirthdayLabel.widthAnchor.constraint(equalTo: birthdayStackView.widthAnchor, multiplier: 0.3).isActive = true
        birthdayStackView.distribution = .fillProportionally
        let stackView = UIStackView(arrangedSubviews: [nameStackView, birthdayStackView, segmentControl])
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        stackView.spacing = 8
        
        nameStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.35).isActive = true
        birthdayStackView.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.35).isActive = true
        segmentControl.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 0.15).isActive = true
        
        containerView.addSubview(stackView)
        
        stackView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 8, paddingRight: 16, width: 0, height: 0)
        
        view.backgroundColor = UIColor.mainBackgroundColor()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleEmployeeSave))
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelButtonClick))
    }
    
    @objc func handleEmployeeSave() {
        print("Save Employee")
        guard let date = validateDate() else { return }
        guard let name = validateName() else { return }
        let res = CoreDataManager.shared.createEmployee(keys: ["name": name, "birthday" : date, "company" : self.company!, "type" : segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex)])
        if let err = res.0 {
            let alertController = UIAlertController(title: "Error while saving employee", message: err.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
        } else {
            self.dismiss(animated: true) {
                self.delegate?.passNewEmployee(employee: res.1)
            }
        }
    }
    
    @objc func handleCancelButtonClick() {
        print("Cancel button click")
        self.dismiss(animated: true, completion: nil)
    }
    
    private func validateName() -> String? {
        let name = nameTextField.text!
        if name.isEmpty {
            let alertController = UIAlertController(title: "Error", message: "You haven't entered employee name", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true)
            return nil
        }
        return name
    }
    
    private func validateDate() -> Date? {
        let arr = BirthdayTextField.text?.split(separator: "/")
        let alertController = UIAlertController(title: "Wrong Date Format", message: "Check the date specification", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        if (arr?.count != 3) {
            
            present(alertController, animated: true, completion: nil)
            return nil
        }
        if (arr?[0].count == 2 && arr?[1].count == 2 && arr?[2].count == 4) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            if let someDateTime = dateFormatter.date(from: BirthdayTextField.text!) {
                return someDateTime
            } else {
                present(alertController, animated: true, completion: nil)
                return nil
            }
        } else {
            present(alertController, animated: true, completion: nil)
            return nil
        }
    }
    
}
