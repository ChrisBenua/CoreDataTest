//
//  CompanyController+Footers.swift
//  CoreDataCourse
//
//  Created by Ирина Улитина on 11/01/2019.
//  Copyright © 2019 Christian Benua. All rights reserved.
//

import Foundation
import UIKit


///MARK:- Footers and headers

extension CompaniesController {
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let label = UILabel()
        
        label.textColor = .white
        label.textAlignment = .center
        let attrText = NSMutableAttributedString(string: "No companies available...\n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16), NSMutableAttributedString.Key.foregroundColor : UIColor.white])
        attrText.append(NSMutableAttributedString(string: "Please, consider adding some companies", attributes: [NSMutableAttributedString.Key.font : UIFont.systemFont(ofSize: 12), NSMutableAttributedString.Key.foregroundColor : UIColor.lightText]))
        label.numberOfLines = 2
        label.attributedText = attrText
        
        return label
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (companies.count == 0) {
            return 100
        }
        return 0
    }
}
