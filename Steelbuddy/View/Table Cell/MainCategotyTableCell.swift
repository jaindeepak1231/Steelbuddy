//
//  MainCategotyTableCell.swift
//  Steelbuddy
//
//  Created by Gaurang Mistry on 12/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class MainCategotyTableCell: UITableViewCell {

    @IBOutlet var viewBG: UIView!
    @IBOutlet var lblCat: UILabel!
    @IBOutlet var btnOpenCat: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
