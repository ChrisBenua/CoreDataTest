//
//  AddCompanyController.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 03/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit
import CoreData

protocol SaveCompanyDelegate : class {
    func passCompany(comapany : Company)
    
    func companyUpdated(company : Company)
}


class AddCompanyController : UIViewController {
    
    weak var delegate : SaveCompanyDelegate?
    
    var editedCompany : Company? {
        didSet {
            selectImageView.image = UIImage(data: editedCompany!.photo!)
            nameTextField.text = editedCompany!.name
            datePicker.date = editedCompany!.founded ?? Date()
            navigationItem.title = "Edit Company"
        }
    }
    
    lazy var selectImageView : UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
        iv.image = #imageLiteral(resourceName: "select_photo_empty")
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showPhotoController)))
        return iv
    }()
    
    lazy var selectPhotoButton : UIButton = {
        let but = UIButton(type: .system)
        
        but.layer.cornerRadius = 8
        but.clipsToBounds = true
        but.layer.borderWidth = 2
        but.setAttributedTitle(NSAttributedString(string: "Select Photo", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18), NSAttributedString.Key.foregroundColor : UIColor.black]), for: .normal)
        but.addTarget(self, action: #selector(showPhotoController), for: .touchUpInside)
        return but
    }()
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Text"
        return label
    }()
    
    let nameTextField : UITextField = {
        let tb = UITextField()
        tb.placeholder = "Enter name"
        tb.font = UIFont.systemFont(ofSize: 14)
        return tb
    }()
    
    let foundedLabel : UILabel = {
        let label = UILabel()
        label.text = "Founded"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        return label
    }()
    
    let foundedDateLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var datePicker : UIDatePicker = {
        let dp = UIDatePicker()
        dp.datePickerMode = UIDatePicker.Mode.date
        dp.addTarget(self, action: #selector(handleDatePickerDateChanged), for: .valueChanged)
        dp.date = Date()
        
        
        return dp
    }()
    
    @objc func showPhotoController() {
        print("Show Photo COntroller")
        
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @objc func handleDatePickerDateChanged() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        
        let strDate = dateFormatter.string(from: datePicker.date)
        foundedDateLabel.text = strDate
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print(selectImageView.bounds)
        
        selectImageView.layer.cornerRadius = selectImageView.bounds.height / 2
        selectImageView.layer.borderWidth = 0.7
        selectImageView.layer.borderColor = UIColor.black.cgColor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleDatePickerDateChanged()
        view.backgroundColor = UIColor.mainBackgroundColor()
        
        if (editedCompany == nil) {
            navigationItem.title = "Create Company"
        }
        navigationController?.navigationBar.isTranslucent = false
        let nameStackView = UIStackView(arrangedSubviews: [nameLabel, nameTextField])
        let foundedStackView = UIStackView(arrangedSubviews: [foundedLabel, foundedDateLabel])
        nameLabel.widthAnchor.constraint(equalTo: nameStackView.widthAnchor, multiplier: 0.25, constant: 0).isActive = true
        nameStackView.distribution = .fillProportionally
        nameStackView.axis = .horizontal
        foundedStackView.distribution = .fillProportionally
        foundedLabel.widthAnchor.constraint(equalTo: foundedStackView.widthAnchor, multiplier: 0.25, constant: 0).isActive = true
        foundedStackView.axis = .horizontal
        let helpView = UIView()
        helpView.addSubview(selectImageView)
        selectImageView.anchor(top: helpView.topAnchor, left: nil, bottom: helpView.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        selectImageView.widthAnchor.constraint(equalTo: selectImageView.heightAnchor, multiplier: 1).isActive = true
        selectImageView.centerXAnchor.constraint(equalTo: helpView.centerXAnchor).isActive = true
        let commonStackView = UIStackView(arrangedSubviews: [helpView, selectPhotoButton, nameStackView, foundedStackView, datePicker])
        commonStackView.distribution = .fillProportionally
        commonStackView.axis = .vertical
        
        helpView.heightAnchor.constraint(equalTo: commonStackView.heightAnchor, multiplier: 0.25, constant: 0).isActive = true
        selectPhotoButton.heightAnchor.constraint(equalTo: commonStackView.heightAnchor, multiplier: 0.1, constant: 0).isActive = true
        nameStackView.heightAnchor.constraint(equalTo: commonStackView.heightAnchor, multiplier: 0.1, constant: 0).isActive = true
        foundedStackView.heightAnchor.constraint(equalTo: commonStackView.heightAnchor, multiplier: 0.1, constant: 0).isActive = true
        
        view.addSubview(commonStackView)
        commonStackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 8, paddingLeft: 16, paddingBottom: 0, paddingRight: 16, width: 0, height: 0)
        
        let helperView : UIView = UIView()
        helperView.backgroundColor = .white
        view.insertSubview(helperView, at: 0)
        helperView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: commonStackView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
        
        commonStackView.spacing = 4
        commonStackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.7).isActive = true
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancelClick))
        
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSaveButton))
        
    }
    
    @objc func handleCancelClick() {
        dismiss(animated: true, completion: nil)
    }
    
    fileprivate func CreateCompany() {
        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: CoreDataManager.shared.context)
        
        company.setValue(nameTextField.text ?? "", forKey: "name")
        company.setValue(datePicker.date, forKey: "founded")
        company.setValue(selectImageView.image?.pngData(), forKey: "photo")
        
        
        do {
            try CoreDataManager.shared.context.save()
            dismiss(animated: true) {
                self.delegate?.passCompany(comapany: company as! Company)
            }
        } catch let err {
            print("Error in saving context AddComapnyController", err)
        }
    }
    
    @objc func handleSaveButton() {
        print("Saving Company")
        
        if editedCompany == nil {
        
            CreateCompany()
        } else {
            
            let context = CoreDataManager.shared.context
            
            editedCompany?.name = nameTextField.text
            editedCompany?.founded = datePicker.date
            editedCompany?.photo = selectImageView.image?.pngData()
            
            do {
                try context.save()
                dismiss(animated: true) {
                    self.delegate?.companyUpdated(company : self.editedCompany!)
                }
            } catch let err {
                print("Failed to Update Company", err)
            }
        }
        
        //let company = //Company(name: textbox.text ?? "", founded : datePicker.date, photo : selectImageView.image?.pngData() ?? Data())
        
        
    }
    
    func coreDataInit() {
        
    }
    
}

extension AddCompanyController : UINavigationControllerDelegate {
    
}
