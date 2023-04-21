//
//  ReceiverTableCell.swift
//  Steelbuddy
//
//  Created by deepak jain on 19/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class ReceiverTableCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblMSg: UILabel!
    @IBOutlet var lbldate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
