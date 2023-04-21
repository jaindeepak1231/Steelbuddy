//
//  ViewAddedInqTableCell.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 10/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class ViewAddedInqTableCell: UITableViewCell {

    @IBOutlet var viewBg: UIView!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblMt: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblGrade: UILabel!
    @IBOutlet var lblMake: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCity: UILabel!
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
