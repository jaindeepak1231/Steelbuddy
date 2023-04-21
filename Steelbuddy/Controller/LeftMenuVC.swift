//
//  LeftMenuVC.swift
//  Butik
//
//  Created by Saturncube on 22/10/16.
//  Copyright © 2016 Saturncube. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class LeftMenuVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var aData = NSArray()
    @IBOutlet var viewBg: UIView!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var btnSigninClicked: UIButton!
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Menu button which was tapped to display the menu
     */
    var btnMenu : UIButton!
    
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        // Do any additional setup after loading the view.
        
        let recogniser = UISwipeGestureRecognizer(target: self, action: #selector(self.didTapButton2(sender:)))
        recogniser.direction = .left
        self.view.addGestureRecognizer(recogniser)
        
    }
    
    func didTapButton2(sender: UIGestureRecognizer!) {
        print("swipe right")
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewBg.backgroundColor = UIColor.white;
        lblName.textColor = UIColor.white;
        
        
        
        updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
        
        if _userDefault.string(forKey: "type") == "b" {
            lblName.text = "BUYER"
            aData = ["Profile", "Sent Inquiry", "View Quotation", "Chat", "Contact Us", "Sign Out"]
        }
        else if _userDefault.string(forKey: "type") == "s" {
            lblName.text = "SELLER"
            aData = ["Profile", "Edit Categories", "View Quotation", "Chat", "View Booked Order", "Contact Us", "Sign Out"]
        }
        

        tblMenuOptions.reloadData()
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
//        if (self.delegate != nil) {
//            var index = Int32(button.tag)
//            if(button == self.btnCloseMenuOverlay){
//                index = -1
//            }
//            delegate?.slideMenuItemSelectedAtIndex(index)
//        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
            }, completion: { (finished) -> Void in
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        })
    }
    
    @IBAction func onClickTableCellMenuClick(_ button:UIButton!){
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(
            withIdentifier: "kCell", for: indexPath)
        let aLabel : UILabel = aCell.viewWithTag(10) as! UILabel
        aLabel.text = aData[indexPath.row] as? String
        
        let aImage : UIImageView = aCell.viewWithTag(20) as! UIImageView
        if aLabel.text == "Profile" {
            aImage.image = #imageLiteral(resourceName: "ic_profile")
        }
        if aLabel.text == "Edit Categories" {
            aImage.image = #imageLiteral(resourceName: "ic_edit_category")
        }
        if aLabel.text == "Sent Inquiry" {
            aImage.image = #imageLiteral(resourceName: "ic_send_enquiry")
        }
        if aLabel.text == "View Quotation" {
            aImage.image = #imageLiteral(resourceName: "ic_view_quotation")
        }
        if aLabel.text == "Chat" {
            aImage.image = #imageLiteral(resourceName: "ic_chat")
        }
        if aLabel.text == "View Booked Order" {
            aImage.image = #imageLiteral(resourceName: "ic_view_booked_order")
        }
        if aLabel.text == "Contact Us" {
            aImage.image = #imageLiteral(resourceName: "ic_location")
        }
        if aLabel.text == "Sign Out" {
            aImage.image = #imageLiteral(resourceName: "ic_action_signout")
        }
        
        return aCell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let btn = UIButton(type: UIButtonType.custom)
        btn.tag = indexPath.row
        self.onClickTableCellMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50;
    }
    
    
}
