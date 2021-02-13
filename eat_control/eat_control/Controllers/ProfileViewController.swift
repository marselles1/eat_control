//
//  ProfileViewController.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var name_label: UILabel!
    @IBOutlet weak var age_label: UILabel!
    @IBOutlet weak var info_label: UILabel!
    
    @IBOutlet weak var daily_insulin_dose_label: UILabel!
    @IBOutlet weak var breakfast_label: UILabel!
    @IBOutlet weak var lunch_label: UILabel!
    @IBOutlet weak var dinner_label: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.loadInfo()
    }

    func loadInfo() {
        let cachedData = (tabBarController as! TabBarViewController).cachedData
        self.name_label.text = cachedData?.name
        if let age = cachedData?.age {
            self.age_label.text = "\(age)"
        }
        self.info_label.text = ""
        if let items = Storage.readProfiles() {
            let item = items.first(where: {$0.name == cachedData?.name})
            if let daily_insulin_dose = item?.daily_insulin_dose {
                if daily_insulin_dose != "" {
                    self.daily_insulin_dose_label.text = "~\(daily_insulin_dose) ед."
                }
            }
            if let breakfast = item?.breakfast {
                if breakfast != "" {
                    self.breakfast_label.text = "\(breakfast) ед./ХЕ"
                }
            }
            if let lunch = item?.lunch {
                if lunch != "" {
                    self.lunch_label.text = "\(lunch) ед./ХЕ"
                }
            }
            if let dinner = item?.dinner {
                if dinner != "" {
                    self.dinner_label.text = "\(dinner) ед./ХЕ"
                }
            }
        }
    }
    
    @IBAction func BtnProfileSettingsClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            UIUtility.showPageViewController(vc: self, identifier: "profile_settings_vc")
        }
    }
    
    @IBAction func BtnSignOutClicked(_ sender: UIButton) {
        self.signOut()
    }
    
    func signOut() {
        do {
            let file_name = "cache_data.json"
            print("Clear cache data...")
            try Storage.remove(file_name, from: .documents)
        } catch {
            print(error.localizedDescription)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    

}
