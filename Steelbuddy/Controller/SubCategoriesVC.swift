//
//  SubCategoriesVC.swift
//  SteelBuddy
//
//  Created by deepak jain on 01/10/2560 BE.
//  Copyright © 2560 BE Jasmine. All rights reserved.
//

import UIKit

class SubCategoriesVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate {

    var strTitle = ""
    var strAddress = ""
    var SelectedIndex = IndexPath()
    var arrMain = [String]()
    var arrMT = [String]()
    var toolBar = UIToolbar()
    var arrOpenExpendCellSections = [Int]()
    var pickerView: UIPickerView = UIPickerView()
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var tblView: UITableView!
    @IBOutlet var viewNavigation: UIView!
    var arrSelectedID = NSMutableArray()
    var arrSubCategory = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        arrOpenExpendCellSections.removeAll()
        
        lblTitle.text = strTitle.uppercased()
        // Add a bottomBorder.
        viewNavigation.layer.masksToBounds = false
        viewNavigation.layer.shadowColor = UIColor.black.cgColor
        viewNavigation.layer.shadowOpacity = 2.5
        viewNavigation.layer.shadowOffset = CGSize(width: -1, height: 1)
        viewNavigation.layer.shadowRadius = 2
        
        //=========================================================//
        arrMT.append("Mt")
        
        //Table Cell Register
        tblView.register(UINib(nibName: "CategoriesTableCell", bundle: nil), forCellReuseIdentifier: "CategoriesTableCell")
        
        tblView.register(UINib(nibName: "AddCategoryTableCell", bundle: nil), forCellReuseIdentifier: "AddCategoryTableCell")
        
        tblView.estimatedRowHeight = 120.0
        tblView.rowHeight = UITableViewAutomaticDimension
        
        print(arrSubCategory)
        tblView.reloadData()
        
        //=======================================================================================//
        //Set Picker
        pickerView.delegate  = self
        toolBar.isTranslucent = false
        toolBar.tintColor = UIColor.black
        toolBar.barStyle = UIBarStyle.default
        toolBar.barTintColor = Constant.themeColor()
        
        let btnCancel = UIButton(type: .custom)
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(60), height: CGFloat(25))
        btnCancel.addTarget(self, action: #selector(self.cancelPressed), for: .touchUpInside)
        let cancelButton = UIBarButtonItem(customView: btnCancel)
        
        let btnDone = UIButton(type: .custom)
        btnDone.setTitle("Done", for: .normal)
        btnDone.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(60), height: CGFloat(25))
        btnDone.addTarget(self, action: #selector(self.donePressed), for: .touchUpInside)
        let doneButton = UIBarButtonItem(customView: btnDone)
        
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        //=========================================================================================//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - TextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //let currentcell = tblView.cellForRow(at: SelectedIndex) as! AddCategoryTableCell
        //currentcell.tblViewForCityState.isHidden = true
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK:-  Picker Done Cancel Action Method
    // MARK: - ToolBar Button Action
    func donePressed(){
        self.view.endEditing(true)
    }
    
    func cancelPressed(){
        self.view.endEditing(true) // or do something
    }
    
    //=====================================================================================//
    // MARK: - PickerView Delegate
    func numberOfComponentsInPickerView(pickerView: UIPickerView!) -> Int{
        return 1
    }
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return arrMT.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrMT[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    }
    
    
    //=====================================================================================//
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        if tableView == tblView {
            return arrSubCategory.count
        }
        else {
            return 1
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if tableView == tblView {
            if arrOpenExpendCellSections.contains(section) {
                let dictCategory = arrSubCategory[section] as! NSDictionary
                if let arrSubCat = dictCategory["addDetail"] as? NSMutableArray {
                    print(arrSubCat.count)
                    return arrSubCat.count
                }
            }
        }
        else {
            return arrMain.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CategoriesTableCell") as? CategoriesTableCell else {
            return UIView()
        }
        
        cell.contentView.backgroundColor = UIColor.white
        
        let dict = arrSubCategory[section] as! NSDictionary
        cell.viewBG.layer.cornerRadius = 8
        cell.viewBG.layer.masksToBounds = true
        cell.viewBG.layer.shadowColor = UIColor.black.cgColor
        cell.viewBG.layer.shadowOpacity = 2.5
        cell.viewBG.layer.shadowOffset = CGSize(width: -1, height: 1)
        cell.viewBG.layer.shadowRadius = 2
        
        let strCatTitle = TO_STRING(dict["vSubName"])
        cell.lblTitle.text = strCatTitle

        let strCatID = TO_INT(dict["iId"])
        if arrSelectedID.contains(strCatID) {
            cell.btnCheck.isSelected = true
        }
        
        
        
        cell.btnOpenCell.tag = section
        cell.btnOpenCell.addTarget(self, action: #selector(self.clkToDropDownOpenSelection), for: .touchUpInside)
        
        cell.btnCheck.tag = section
        cell.btnCheck.addTarget(self, action: #selector(self.clkToSelectorNotCategorySelection), for: .touchUpInside)
        
        
        
        
        return cell.contentView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == tblView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCategoryTableCell", for: indexPath as IndexPath) as! AddCategoryTableCell
            
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets.zero
            
            cell.viewDeleteBG.layer.cornerRadius = 8
            cell.viewDeleteBG.layer.masksToBounds = true
            cell.viewDeleteBG.layer.shadowColor = UIColor.black.cgColor
            cell.viewDeleteBG.layer.shadowOpacity = 2.5
            cell.viewDeleteBG.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.viewDeleteBG.layer.shadowRadius = 2
            
            cell.viewAddOtherBG.layer.cornerRadius = 8
            cell.viewAddOtherBG.layer.masksToBounds = true
            cell.viewAddOtherBG.layer.shadowColor = UIColor.black.cgColor
            cell.viewAddOtherBG.layer.shadowOpacity = 2.5
            cell.viewAddOtherBG.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.viewAddOtherBG.layer.shadowRadius = 2
            
            cell.tblViewForCityState.layer.masksToBounds = false
            cell.tblViewForCityState.layer.shadowColor = UIColor.black.cgColor
            cell.tblViewForCityState.layer.shadowOpacity = 2.5
            cell.tblViewForCityState.layer.shadowOffset = CGSize(width: -1, height: 1)
            cell.tblViewForCityState.layer.shadowRadius = 2
            
            let dictCategory = arrSubCategory[indexPath.section] as! NSDictionary
            if let arrSubCat = dictCategory["addDetail"] as? NSMutableArray {
                
                var dict: NSDictionary = [:]
                dict = arrSubCat.object(at:indexPath.row) as! NSDictionary
                cell.txtCity.text = TO_STRING(dict["city"])
                cell.txtMake.text = TO_STRING(dict["make"])
                cell.txtSize.text = TO_STRING(dict["size"])
                cell.txtGrade.text = TO_STRING(dict["grade"])
                cell.txtState.text = TO_STRING(dict["state"])
                cell.txtQuantity.text = TO_STRING(dict["quantity"])
                
                let check = arrSubCat.count - 1
                if indexPath.row == check {
                    cell.lblAddOther.isHidden = false
                    cell.imgAddOther.isHidden = false
                    cell.constraint_add_other_height.constant = 40
                }
                else {
                    cell.lblAddOther.isHidden = true
                    cell.imgAddOther.isHidden = true
                    cell.constraint_add_other_height.constant = 0
                }
            }
            
            //Table Register
            cell.tblViewForCityState.register(UINib(nibName: "CityStateTableCell", bundle: nil), forCellReuseIdentifier: "CityStateTableCell")
            
            cell.tblViewForCityState.estimatedRowHeight = 60.0
            cell.tblViewForCityState.rowHeight = UITableViewAutomaticDimension
            cell.tblViewForCityState.isHidden = true
            
            //For TextField
            cell.txtQuantity.delegate = self
            cell.txtGrade.delegate = self
            cell.txtSize.delegate = self
            cell.txtMake.delegate = self
            cell.txtCity.delegate = self
            cell.txtState.delegate = self
            cell.tblViewForCityState.delegate = self
            cell.tblViewForCityState.dataSource = self
            
            
            cell.txtQuantity.tag = indexPath.row
            cell.txtQuantity.addTarget(self, action: #selector(self.txtQuantitySet), for: .editingChanged)
            
            cell.txtQuantity.tag = indexPath.row
            cell.txtQuantity.addTarget(self, action: #selector(self.txtQuantityKeyboardChane), for: .editingDidBegin)
            
            cell.txtMt.tag = indexPath.row
            cell.txtMt.addTarget(self, action: #selector(self.txtMtSet), for: .editingDidBegin)
            
            cell.txtGrade.tag = indexPath.row
            cell.txtGrade.addTarget(self, action: #selector(self.txtGradeSet), for: .editingChanged)
            
            cell.txtSize.tag = indexPath.row
            cell.txtSize.addTarget(self, action: #selector(self.txtSizeSet), for: .editingChanged)
            
            cell.txtMake.tag = indexPath.row
            cell.txtMake.addTarget(self, action: #selector(self.txtMakeSet), for: .editingChanged)
            
            cell.txtCity.tag = indexPath.row
            cell.txtCity.addTarget(self, action: #selector(self.txtCitySet), for: .editingChanged)
            
            cell.txtState.tag = indexPath.row
            cell.txtState.addTarget(self, action: #selector(self.txtStateSet), for: .editingChanged)
            
            //For Button
            cell.btnAddOther.tag = indexPath.row
            cell.btnAddOther.addTarget(self, action: #selector(self.clkToAddOtherTaped), for: .touchUpInside)
            
            cell.btnDelete.tag = indexPath.row
            cell.btnDelete.addTarget(self, action: #selector(self.clkToDeleteTaped), for: .touchUpInside)
            
            
            
            
            return cell
            
        }
        else {
            let Addcell = tableView.dequeueReusableCell(withIdentifier: "CityStateTableCell", for: indexPath as IndexPath) as! CityStateTableCell
            
            Addcell.backgroundColor = UIColor.white
            Addcell.selectionStyle = .none
            Addcell.separatorInset = UIEdgeInsets.zero
            
            Addcell.lblTitle.text = arrMain[indexPath.row]
            
            
            return Addcell
        }
        
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if tableView == tblView {
            return 65.0
        }
        else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == tblView {
        }
        else {
            let currentcell = tblView.cellForRow(at: SelectedIndex) as! AddCategoryTableCell
            
            var dictiChange = NSMutableDictionary()
            let dicti = arrSubCategory.object(at:SelectedIndex.section) as! NSDictionary
            dictiChange = dicti.mutableCopy() as! NSMutableDictionary
            let dictCategory = arrSubCategory[SelectedIndex.section] as! NSDictionary
            let arrTemp = dictCategory["addDetail"] as? NSMutableArray
            var dictiTextChange: Dictionary<String,Any> = [:]
            dictiTextChange = arrTemp?.object(at:SelectedIndex.row) as! Dictionary<String, Any>
            if strAddress == "City" {
                currentcell.txtCity.text = arrMain[indexPath.row]
                dictiTextChange.updateValue(currentcell.txtCity.text!, forKey: "city")
            }
            if strAddress == "State" {
                currentcell.txtState.text = arrMain[indexPath.row]
                dictiTextChange.updateValue(currentcell.txtState.text!, forKey: "state")
            }
            arrTemp?.replaceObject(at: SelectedIndex.row, with: dictiTextChange)
            arrSubCategory.replaceObject(at: SelectedIndex.section, with: dictiChange)
            print(arrSubCategory)
            currentcell.tblViewForCityState.isHidden = true
        }
    }
    
    
    
    
    
    @IBAction func clkToDropDownOpenSelection(_ sender: UIButton) {
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:sender.tag) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        
        let SelectedID = TO_INT(dictiChange["iId"])
        
        let param = ["quantity" : "",
                     "size"     : "",
                     "grade"    : "",
                     "make"     : "",
                     "state"    : "",
                     "city"     : ""]
        let arrTem = NSMutableArray()
        arrTem.add(param)
        dictiChange.setValue(arrTem, forKey: "addDetail")
        arrSubCategory.replaceObject(at: sender.tag, with: dictiChange)
        
        if arrOpenExpendCellSections.contains(sender.tag) {
            if let index = arrOpenExpendCellSections.index(of:sender.tag) {
                arrOpenExpendCellSections.remove(at: index)
            }
        }
        else {
            arrSelectedID.add(SelectedID)
            arrOpenExpendCellSections.append(sender.tag)
        }
        
        tblView.reloadData()
    }
    
    
    @IBAction func clkToSelectorNotCategorySelection(_ sender: UIButton) {
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:sender.tag) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        let SelectedID = TO_INT(dictiChange["iId"])
        let param = ["quantity" : "",
                     "size"     : "",
                     "grade"    : "",
                     "make"     : "",
                     "state"    : "",
                     "city"     : ""]
        let arrTem = NSMutableArray()
        arrTem.add(param)
        
        if arrOpenExpendCellSections.contains(sender.tag) {
            if let index = arrOpenExpendCellSections.index(of:sender.tag) {
                arrOpenExpendCellSections.remove(at: index)
                arrSelectedID.remove(SelectedID)
                dictiChange.removeObject(forKey: "addDetail")
                arrSubCategory.replaceObject(at: sender.tag, with: dictiChange)
            }
        }
        else {
            arrSelectedID.add(SelectedID)
            arrOpenExpendCellSections.append(sender.tag)
            dictiChange.setValue(arrTem, forKey: "addDetail")
            arrSubCategory.replaceObject(at: sender.tag, with: dictiChange)
        }
        
        tblView.reloadData()
    }
    
    
    @IBAction func clkToAddOtherTaped(_ sender: UIButton) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnAdd)!
        var dictiChange = NSMutableDictionary()
        print(arrSubCategory)
        
        let dicti = arrSubCategory.object(at:index.section) as! NSDictionary
        print(dicti)
        
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        print( dictiChange )
        
        
        
        let dictCategory = arrSubCategory[index.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        
        let param = ["quantity" : "",
                     "size"     : "",
                     "grade"    : "",
                     "make"     : "",
                     "state"    : "",
                     "city"     : ""]
        arrTemp?.add(param)
        dictiChange.setValue(arrTemp, forKey: "addDetail")
        print(dictiChange)
        arrSubCategory.replaceObject(at: index.section, with: dictiChange)
        print(arrSubCategory)
        
        
        tblView.reloadData()

    }
    
    
    @IBAction func clkToDeleteTaped(_ sender: UIButton) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnAdd)!
        var dictiChange = NSMutableDictionary()
        print(arrSubCategory)
        
        let dicti = arrSubCategory.object(at:index.section) as! NSDictionary
        print(dicti)
        
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        print( dictiChange )
        
        let SelectedID = TO_INT(dictiChange["iId"])
        
        let dictCategory = arrSubCategory[index.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        
        var dict: NSDictionary = [:]
        dict = arrTemp?.object(at:index.row) as! NSDictionary
        
        arrTemp?.remove(dict)
        
        if arrTemp?.count == 0 {
            arrSelectedID.remove(SelectedID)
        }
        
        dictiChange.setValue(arrTemp, forKey: "addDetail")
        print(dictiChange)
        arrSubCategory.replaceObject(at: index.section, with: dictiChange)
        print(arrSubCategory)
        
        
        tblView.reloadData()
        
    }
    
    
    //For Cell in Textfield Value
    // MARK: - txtField
    func txtQuantitySet(_ sender: UITextField) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnAdd)!
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:index.section) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        let dictCategory = arrSubCategory[index.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrTemp?.object(at:(sender.tag)) as! Dictionary<String, Any>
        dictiTextChange.updateValue(sender.text ?? 0, forKey: "quantity")
        arrTemp?.replaceObject(at: (sender.tag), with: dictiTextChange)
        arrSubCategory.replaceObject(at: index.section, with: dictiChange)
        print(arrSubCategory)
    }
    
    func txtQuantityKeyboardChane(_ sender: UITextField) {
        sender.keyboardType = .numberPad
    }
    
    func txtMtSet(_ sender: UITextField) {
        print("Open")
        sender.inputAccessoryView = toolBar
        sender.inputView = pickerView
        pickerView.selectRow(0, inComponent: 0, animated: true)
        pickerView.reloadAllComponents()
        sender.becomeFirstResponder()
    }
    
    
    func txtGradeSet(_ sender: UITextField) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnAdd)!
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:index.section) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        let dictCategory = arrSubCategory[index.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrTemp?.object(at:(sender.tag)) as! Dictionary<String, Any>
        dictiTextChange.updateValue(sender.text ?? 0, forKey: "grade")
        arrTemp?.replaceObject(at: (sender.tag), with: dictiTextChange)
        arrSubCategory.replaceObject(at: index.section, with: dictiChange)
        print(arrSubCategory)
    }
    
    func txtSizeSet(_ sender: UITextField) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnAdd)!
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:index.section) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        let dictCategory = arrSubCategory[index.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrTemp?.object(at:(sender.tag)) as! Dictionary<String, Any>
        dictiTextChange.updateValue(sender.text ?? 0, forKey: "size")
        arrTemp?.replaceObject(at: (sender.tag), with: dictiTextChange)
        arrSubCategory.replaceObject(at: index.section, with: dictiChange)
        print(arrSubCategory)
    }
    
    func txtMakeSet(_ sender: UITextField) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        let index = tblView.indexPathForRow(at: btnAdd)!
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:index.section) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        let dictCategory = arrSubCategory[index.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrTemp?.object(at:(sender.tag)) as! Dictionary<String, Any>
        dictiTextChange.updateValue(sender.text ?? 0, forKey: "make")
        arrTemp?.replaceObject(at: (sender.tag), with: dictiTextChange)
        arrSubCategory.replaceObject(at: index.section, with: dictiChange)
        print(arrSubCategory)
    }
    
    func txtCitySet(_ sender: UITextField) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        SelectedIndex = tblView.indexPathForRow(at: btnAdd)!
        let currentcell = tblView.cellForRow(at: SelectedIndex)! as! AddCategoryTableCell
        if (sender.text! == "") {
            currentcell.tblViewForCityState.isHidden = true
        }
        else {
            currentcell.constraint_bottom_Constant.constant = -35
            arrMain.removeAll()
            strAddress = "City"
            for i in 0..<app_Delegate.arrCity.count {
            let strCountry = app_Delegate.arrCity[i]
                if strCountry.lowercased().range(of: sender.text!) != nil {
                    if arrMain.count < 3 {
                        arrMain.append(strCountry)
                    }
                    currentcell.tblViewForCityState.isHidden = false
                }
                else if strCountry == sender.text! {
                    currentcell.tblViewForCityState.isHidden = true
                }
                
                currentcell.tblViewForCityState.reloadData()
            }
        }
        
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:SelectedIndex.section) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        let dictCategory = arrSubCategory[SelectedIndex.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrTemp?.object(at:(sender.tag)) as! Dictionary<String, Any>
        dictiTextChange.updateValue(sender.text ?? 0, forKey: "city")
        arrTemp?.replaceObject(at: (sender.tag), with: dictiTextChange)
        arrSubCategory.replaceObject(at: SelectedIndex.section, with: dictiChange)
        print(arrSubCategory)
        
    }
    
    func txtStateSet(_ sender: UITextField) {
        let btnAdd = (sender as AnyObject).convert(CGPoint.zero, to: tblView)
        SelectedIndex = tblView.indexPathForRow(at: btnAdd)!
        let currentcell = tblView.cellForRow(at: SelectedIndex)! as! AddCategoryTableCell
        if (sender.text! == "") {
            currentcell.tblViewForCityState.isHidden = true
        }
        else {
            currentcell.constraint_bottom_Constant.constant = 0
            arrMain.removeAll()
            strAddress = "State"
            for i in 0..<app_Delegate.arrState.count {
                let strCountry = app_Delegate.arrState[i]
                if strCountry.lowercased().range(of: sender.text!) != nil {
                    if arrMain.count < 3 {
                        arrMain.append(strCountry)
                    }
                    currentcell.tblViewForCityState.isHidden = false
                }
                else if strCountry == sender.text! {
                    currentcell.tblViewForCityState.isHidden = true
                }
                currentcell.tblViewForCityState.reloadData()
            }
        }
        
        
        var dictiChange = NSMutableDictionary()
        let dicti = arrSubCategory.object(at:SelectedIndex.section) as! NSDictionary
        dictiChange = dicti.mutableCopy() as! NSMutableDictionary
        let dictCategory = arrSubCategory[SelectedIndex.section] as! NSDictionary
        let arrTemp = dictCategory["addDetail"] as? NSMutableArray
        var dictiTextChange: Dictionary<String,Any> = [:]
        dictiTextChange = arrTemp?.object(at:(sender.tag)) as! Dictionary<String, Any>
        dictiTextChange.updateValue(sender.text ?? 0, forKey: "state")
        arrTemp?.replaceObject(at: (sender.tag), with: dictiTextChange)
        arrSubCategory.replaceObject(at: SelectedIndex.section, with: dictiChange)
        print(arrSubCategory)
    }
    
    
    
    
    
    
    //==========================================================================================//

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
    
    @IBAction func clkTobtnSubmitAction(_ sender: UIButton) {
        self.view.endEditing(true)
        let finalArray = NSMutableArray()
        if arrSelectedID.count == 0 {
            self.view.endEditing(true)
            Constant.showAlert(title: "Steelbuddy", message: "Please select atleast one category")
            return
        }
        else {
            for i in 0..<arrSubCategory.count {
                let dictCategory = arrSubCategory[i] as! NSDictionary
                if let arrSubCat = dictCategory["addDetail"] as? NSMutableArray {
                    for j in 0..<arrSubCat.count {
                        var dictiTextChange: Dictionary<String,Any> = [:]
                        dictiTextChange = arrSubCat.object(at: j) as! Dictionary<String, Any>
                        let quantity = TO_STRING(dictiTextChange["quantity"])
                        let size = TO_STRING(dictiTextChange["size"])
                        let grade = TO_STRING(dictiTextChange["grade"])
                        let make = TO_STRING(dictiTextChange["make"])
                        let state = TO_STRING(dictiTextChange["state"])
                        let city = TO_STRING(dictiTextChange["city"])
                        
                        if quantity == "" {
                            Constant.showAlert(title: "Steelbuddy", message: "Please enter Quantity")
                            return
                        }
                        else if size == "" {
                            Constant.showAlert(title: "Steelbuddy", message: "Please enter Size")
                            return
                        }
                        else if grade == "" {
                            Constant.showAlert(title: "Steelbuddy", message: "Please enter Grade")
                            return
                        }
                        else if make == "" {
                            Constant.showAlert(title: "Steelbuddy", message: "Please enter Make")
                            return
                        }
                        else if state == "" {
                            Constant.showAlert(title: "Steelbuddy", message: "Please enter State")
                            return
                        }
                        else if city == "" {
                            Constant.showAlert(title: "Steelbuddy", message: "Please enter City")
                            return
                        }
                        finalArray.add(dictCategory)
                    }
                }
            }
            print(finalArray)
            
            let objAddedDispaly = self.storyboard?.instantiateViewController(withIdentifier: "ViewAddedInquiryVC") as! ViewAddedInquiryVC
            objAddedDispaly.arrSelectedCategory = finalArray
            self.navigationController?.pushViewController(objAddedDispaly, animated: true)
        }
    }
}

