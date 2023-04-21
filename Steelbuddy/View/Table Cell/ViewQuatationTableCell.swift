//
//  ViewQuatationTableCell.swift
//  Steelbuddy
//
//  Created by deepak jain on 16/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class ViewQuatationTableCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblQuatationTitle: UILabel!
    @IBOutlet var lblQuantity: UILabel!
    @IBOutlet var lblMt: UILabel!
    @IBOutlet var lblSize: UILabel!
    @IBOutlet var lblGrade: UILabel!
    @IBOutlet var lblMake: UILabel!
    @IBOutlet var lblState: UILabel!
    @IBOutlet var lblCity: UILabel!
    @IBOutlet var lblGST: UILabel!
    @IBOutlet var lblDelivery: UILabel!
    @IBOutlet var lblLoadingTitle: UILabel!
    @IBOutlet var lblLoading: UILabel!
    @IBOutlet var lblPayment: UILabel!
    @IBOutlet var lblPriceTitle: UILabel!
    @IBOutlet var lblPrice: UILabel!
    @IBOutlet var lblDate: UILabel!
    @IBOutlet var viewExtraBg: UIView!
    @IBOutlet var btnViewDetail: UIButton!
    @IBOutlet var btnChat: UIButton!
    
    @IBOutlet var constrain_view_extra_height: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
