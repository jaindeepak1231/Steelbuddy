//
//  QuatationTableCell.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 14/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class QuatationTableCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnView: UIButton!
    @IBOutlet var lblUnderKLine: UILabel!
    @IBOutlet var lblSecondUnderLine: UILabel!
    @IBOutlet var lblThirdUnderLine: UILabel!
    
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var btnChat: UIButton!
    @IBOutlet var btnbook: UIButton!
    
    @IBOutlet var viewExtraBg: UIView!
    @IBOutlet var lblQuatationTitle: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblMt: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblGrade: UILabel!
    @IBOutlet var lblMake: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblDelivery: UILabel!
    @IBOutlet var lblLoading: UILabel!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblGST: UILabel!
    
    @IBOutlet var lblDeliveryTitle: UILabel!
    @IBOutlet var lblLoadingTitle: UILabel!
    @IBOutlet var lblPaymentTitle: UILabel!
    @IBOutlet var lblGSTTitle: UILabel!
    
    
    
    @IBOutlet var constraint_button_top: NSLayoutConstraint!
    @IBOutlet var constraint_date_top: NSLayoutConstraint!
    @IBOutlet var constrain_view_extra_height: NSLayoutConstraint!
    @IBOutlet var constraint_title_top: NSLayoutConstraint!
    @IBOutlet var constrain_view_top: NSLayoutConstraint!
    @IBOutlet var constraint_view_bottom: NSLayoutConstraint!
    @IBOutlet var constraint_top: NSLayoutConstraint!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var Constraint_TopView_height: NSLayoutConstraint!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblThirdUnderLine.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
