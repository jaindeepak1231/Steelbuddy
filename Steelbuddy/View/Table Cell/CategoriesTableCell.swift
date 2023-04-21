//
//  CategoriesTableCell.swift
//  Steelbuddy
//
//  Created by deepak jain on 07/10/2560 BE.
//  Copyright © 2560 BE deepak jain. All rights reserved.
//

import UIKit

class CategoriesTableCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnCheck: UIButton!
    @IBOutlet var btnOpenCell: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
