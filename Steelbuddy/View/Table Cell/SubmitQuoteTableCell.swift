//
//  SubmitQuoteTableCell.swift
//  Steelbuddy
//
//  Created by deepak jain on 15/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class SubmitQuoteTableCell: UITableViewCell {

    @IBOutlet var viewBg: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblQuentity: UILabel!
    @IBOutlet var lblMt: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblGrade: UILabel!
    @IBOutlet var lblMake: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblGST: UILabel!
    @IBOutlet var btnEx: UIButton!
    @IBOutlet var viewLoading: UIView!
    @IBOutlet var btnFor: UIButton!
    @IBOutlet var btnExtra: UIButton!
    @IBOutlet var btnInclude: UIButton!
    @IBOutlet var txtPayments: UITextField!
    @IBOutlet var txtPrice: UITextField!
    @IBOutlet var btnSubmit: UIButton!
    
    @IBOutlet var constraint_btn_height: NSLayoutConstraint!
    @IBOutlet var constraint_view_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
