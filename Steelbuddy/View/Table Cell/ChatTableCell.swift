//
//  ChatTableCell.swift
//  Steelbuddy
//
//  Created by deepak jain on 21/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class ChatTableCell: UITableViewCell {

    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
