//
//  CompanyTableViewCell.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 31/12/2018.
//  Copyright © 2018 Christian Benua. All rights reserved.
//

import Foundation
import UIKit

class CompanyTableViewCell : UITableViewCell {
    
    
    var company : Company! {
        didSet {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd, yyyy"
            
            
            
            if let date = company.founded, let name = company.name {
                companyNameLabel.text = name +  " - Founded: " + dateFormatter.string(from: date)
            } else {
                companyNameLabel.text = company.name!
            }

            guard let data = company.photo else {
                return
            }
            myImageView.image = UIImage(data: data)
        }
    }
    
    let myImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let companyNameLabel : UILabel = {
       let label = UILabel()
        label.textColor = .white
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(myImageView)
        contentView.addSubview(companyNameLabel)
        
        contentView.backgroundColor = UIColor.mainCellBackgroundColor()
        
        myImageView.anchor(top: contentView.topAnchor, left: contentView.leftAnchor, bottom: contentView.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 0, width: 0, height: 0)
        myImageView.widthAnchor.constraint(equalTo: myImageView.heightAnchor).isActive = true
        
        myImageView.layer.cornerRadius = (70 - 16) / 2
        
        companyNameLabel.anchor(top: contentView.topAnchor, left: myImageView.rightAnchor, bottom: contentView.bottomAnchor, right: contentView.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
