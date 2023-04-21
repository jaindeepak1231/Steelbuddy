//
//  QuatationDetailVC.swift
//  Steelbuddy
//
//  Created by khatri Jigar on 14/10/17.
//  Copyright © 2017 deepak jain. All rights reserved.
//

import UIKit

class QuatationDetailVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var strScreenFrom = ""
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var arrCompnayData = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if strScreenFrom == "seller" {
            lblTitle.text = "VIEW DETAILS"
        }
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        //=========================================================//
        //Table Cell Register
        
        tblView.register(UINib(nibName: "CompanyViewTableCell", bundle: nil), forCellReuseIdentifier: "CompanyViewTableCell")
        
        tblView.estimatedRowHeight = 120.0
        tblView.rowHeight = UITableViewAutomaticDimension
        //============================================================================================//
        
        print(arrCompnayData)
        tblView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //=====================================================================================//
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        //if strScreenFrom == "seller" {
            return 1
//        }
//        else {
//            return arrCompnayData.count
//        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CompanyViewTableCell", for: indexPath as IndexPath) as! CompanyViewTableCell
        
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets.zero
        
        var dictCat: NSDictionary = [:]
        if arrCompnayData.count == 1 {
            dictCat = arrCompnayData.object(at:0) as! NSDictionary
        }
        else {
            dictCat = arrCompnayData.object(at: indexPath.row) as! NSDictionary
        }
        cell.lblTitle.text = TO_STRING(dictCat["company_name"])
        cell.lblName.text = TO_STRING(dictCat["name"])
        cell.lblAddress.text = TO_STRING(dictCat["address"])
        cell.lblCity.text = TO_STRING(dictCat["city"])
        cell.lblState.text = TO_STRING(dictCat["state"])
        cell.lblCountry.text = TO_STRING(dictCat["country"])
        cell.lblMobile.text = TO_STRING(dictCat["mobile"])
        cell.lblEmail.text = TO_STRING(dictCat["email"])
        cell.lblGstNumber.text = TO_STRING(dictCat["vGstNo"])
        
        cell.btnDelete.isHidden = true
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    
    @IBAction func clkToButtonViewQuatationDetailTaped(_ sender: UIButton) {
        let objDetail = self.storyboard?.instantiateViewController(withIdentifier: "QuatationDetailVC") as! QuatationDetailVC
        self.navigationController?.pushViewController(objDetail, animated: true)
    }
    
    
    @IBAction func clkToButtonChatTaped(_ sender: UIButton) {
    }
    
    @IBAction func clkToButtonBookTaped(_ sender: UIButton) {
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    // MARK: - Left Menu Display Button Method
    @IBAction func clkToBackAction(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}




