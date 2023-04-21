//
//  ViewQuatatioTableCell.swift
//  Steelbuddy
//
//  Created by deepak jain on 12/11/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class ViewQuatatioTableCell: UITableViewCell {

    @IBOutlet var viewMainBG: UIView!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var viewExtraBG: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var lblUnderKLine: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnbook: UIButton!
    @IBOutlet var constraint_button_top: NSLayoutConstraint!
    @IBOutlet var constraint_view_bottom: NSLayoutConstraint!
    @IBOutlet var constraint_top: NSLayoutConstraint!
    @IBOutlet var Constraint_TopView_height: NSLayoutConstraint!
    @IBOutlet var constraint_view_field_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
