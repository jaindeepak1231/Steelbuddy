//
//  NotificationTableCell.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 31/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class NotificationTableCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDescription: UILabel!
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
