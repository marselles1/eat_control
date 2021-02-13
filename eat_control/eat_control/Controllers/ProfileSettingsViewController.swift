//
//  ProfileSettingsViewController.swift
//  eat_control
//
//  Created by marsel on 13.02.2021.
//

import UIKit

class ProfileSettingsViewController: UIViewController {

    @IBOutlet weak var daily_insulin_dose_field: UITextField!
    @IBOutlet weak var breakfast_field: UITextField!
    @IBOutlet weak var lunch_field: UITextField!
    @IBOutlet weak var dinner_field: UITextField!
    var name: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadInfo()
        self.daily_insulin_dose_field.inputAccessoryView = self.getToolbar()
        self.breakfast_field.inputAccessoryView = self.getToolbar()
        self.lunch_field.inputAccessoryView = self.getToolbar()
        self.dinner_field.inputAccessoryView = self.getToolbar()
    }
    
    
    func getToolbar() -> UIToolbar {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.hideKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.hideKeyboard))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        return toolBar
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func loadInfo() {
        let cachedData = (tabBarController as! TabBarViewController).cachedData
        self.name = cachedData?.name
        if let items = Storage.readProfiles() {
            let item = items.first(where: {$0.name == cachedData?.name})
            if let daily_insulin_dose = item?.daily_insulin_dose {
                if daily_insulin_dose != "" {
                    self.daily_insulin_dose_field.text = "\(daily_insulin_dose)"
                }
            }
            if let breakfast = item?.breakfast {
                self.breakfast_field.text = "\(breakfast)"
            }
            if let lunch = item?.lunch {
                self.lunch_field.text = "\(lunch)"
            }
            if let dinner = item?.dinner {
                self.dinner_field.text = "\(dinner)"
            }
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.saveChanges()
    }
    
    func saveChanges() {
        if self.existChanges() {
            var listProfiles: [ProfileModel]!
            listProfiles = Storage.readProfiles()
            if listProfiles != nil {
                for i in 0...listProfiles.count - 1 {
                    if listProfiles[i].name == self.name {
                        listProfiles[i].daily_insulin_dose = self.daily_insulin_dose_field.text
                        listProfiles[i].breakfast = self.breakfast_field.text
                        listProfiles[i].lunch = self.lunch_field.text
                        listProfiles[i].dinner = self.dinner_field.text
                    }
                }
                Storage.writeProfiles(json_data: listProfiles)
            }
        }
    }
    
    func existChanges() -> Bool {
        if self.daily_insulin_dose_field.text != "" || self.breakfast_field.text != "" || self.lunch_field.text != "" || self.dinner_field.text != "" {
            return true
        }
        return false
    }
    
}
