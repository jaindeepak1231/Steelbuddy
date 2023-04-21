//
//  CompanyViewTableCell.swift
//  Steelbuddy
//
//  Created by khatri Jigar on 14/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class CompanyViewTableCell: UITableViewCell {

    @IBOutlet var viewBg: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCountry: UILabel!
    @IBOutlet var lblMobile: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var lblGstNumber: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var constraint_top_space: NSLayoutConstraint!
    @IBOutlet var constraint_bottom_space: NSLayoutConstraint!
    @IBOutlet var Constraint_view_Bottom: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
