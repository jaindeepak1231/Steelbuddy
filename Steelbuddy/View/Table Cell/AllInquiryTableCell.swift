//
//  AllInquiryTableCell.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 11/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class AllInquiryTableCell: UITableViewCell {

    @IBOutlet var viewBg: UIView!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblMt: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblGrade: UILabel!
    @IBOutlet var lblMake: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblUnderLine: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnDelete: UIButton!
    @IBOutlet var constraint_top_space: NSLayoutConstraint!
    @IBOutlet var Contraint_botton_view_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        btnDelete.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
