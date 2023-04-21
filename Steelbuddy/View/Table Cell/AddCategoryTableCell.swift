//
//  AddCategoryTableCell.swift
//  Steelbuddy
//
//  Created by deepak jain on 07/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class AddCategoryTableCell: UITableViewCell {

    @IBOutlet var txtQuantity: UITextField!
    @IBOutlet var txtMt: UITextField!
    @IBOutlet var txtSize: UITextField!
    @IBOutlet var txtGrade: UITextField!
    @IBOutlet var txtMake: UITextField!
    @IBOutlet var txtState: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var btnAddOther: UIButton!
    @IBOutlet var viewDeleteBG: UIView!
    @IBOutlet var viewAddOtherBG: UIView!
    @IBOutlet var lblAddOther: UILabel!
    @IBOutlet var imgAddOther: UIImageView!
    @IBOutlet var tblViewForCityState: UITableView!
    @IBOutlet var constraint_bottom_Constant: NSLayoutConstraint!
    @IBOutlet var constraint_add_other_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
