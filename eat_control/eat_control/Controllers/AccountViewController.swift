//
//  AccountViewController.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import UIKit

class AccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var title_label: UILabel!
    @IBOutlet weak var login_label: UITextField!
    @IBOutlet weak var password_label: UITextField!
    @IBOutlet weak var age_label: UITextField!
    
    @IBOutlet weak var auth_btn: UIButton!
    @IBOutlet weak var reg_btn: UIButton!
    
    var registration_mode: Bool!
    
    //Return button on keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (login_label.text?.isEmpty ?? true) {
            password_label.isEnabled = false
            textField.resignFirstResponder()
        } else if textField == login_label {
            password_label.isEnabled = true
            password_label.becomeFirstResponder()
        } else if registration_mode {
            age_label.isEnabled = true
            age_label.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        self.login_label.inputAccessoryView = self.getToolbar()
//        self.password_label.inputAccessoryView = self.getToolbar()
        self.age_label.inputAccessoryView = self.getToolbar()
        if let cached_data = self.check_cache_data() {
            DispatchQueue.main.async {
                UIUtility.presentMainViewController(vc: self, cachedData: cached_data)
            }
        }
        self.showAuth()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.hideKeyboard()
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
    
    @IBAction func btnAuthClicked(_ sender: UIButton) {
        if registration_mode {
            self.showAuth()
        } else {
            self.signIn()
        }
        self.hideKeyboard()
    }
    
    @IBAction func btnRegClicked(_ sender: UIButton) {
        if registration_mode {
            self.registration()
        } else {
            self.showRegistration()
        }
        self.hideKeyboard()
    }

    func showAuth() {
        self.registration_mode = false
        self.title_label.text = "Авторизация"
        self.age_label.isHidden = true
        self.password_label.returnKeyType = UIReturnKeyType.done
        self.password_label.enablesReturnKeyAutomatically = true
        self.auth_btn.setTitle("Войти", for: .normal)
        self.reg_btn.setTitle("Зарегистрироваться", for: .normal)
    }
    
    func showRegistration() {
        self.registration_mode = true
        self.title_label.text = "Регистрация"
        self.age_label.isHidden = false
        self.password_label.returnKeyType = UIReturnKeyType.next
        self.password_label.enablesReturnKeyAutomatically = false
        self.auth_btn.setTitle("Авторизация", for: .normal)
        self.reg_btn.setTitle("Регистрация", for: .normal)
    }
    
    func registration() {
        if self.check_auth_data() {
            var json_data: [ProfileModel]?
            let cache_data = CachedModel(name: self.login_label.text, age: Int(self.age_label.text ?? ""), password: self.password_label.text)
            json_data = Storage.readProfiles()
            if json_data != nil {
                json_data!.append(ProfileModel(name: cache_data.name, age: cache_data.age, password: cache_data.password))
            } else {
                json_data = [ProfileModel(name: cache_data.name, age: cache_data.age, password: cache_data.password)]
            }
            Storage.writeProfiles(json_data: json_data)
            self.write_cache_data(cache_data: cache_data)
            DispatchQueue.main.async {
                UIUtility.presentMainViewController(vc: self, cachedData: cache_data)
            }
        }
    }
    
    func check_auth_data() -> Bool {
        if self.login_label.text != "" {
            if self.password_label.text != "" {
                return true
            } else {
                Toast.show(message: "Отсутствует пароль!", view: view)
            }
        } else {
            Toast.show(message: "Отсутствует логин!", view: view)
        }
        return false
    }
    
    func check_cache_data() -> CachedModel? {
        var json_data: CachedModel?
        let file_name = "cache_data.json"
        do {
            print("Read cache data...")
            json_data = try Storage.retrieve(file_name, from: .documents, as: CachedModel.self)
            print(json_data)
        } catch {
            print(error.localizedDescription)
        }
        return json_data
    }
    
    func write_cache_data(cache_data: CachedModel) {
        let file_name = "cache_data.json"
        do {
            print("Create cache data...")
            try Storage.store(cache_data, to: .documents, as: file_name)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func signIn() {
        if self.check_auth_data() {
            var json_data: [ProfileModel]?
            json_data = Storage.readProfiles()
            if let auth_result = json_data?.first(where: {$0.name == self.login_label.text}) {
                if auth_result.password == self.password_label.text {
                    let cache_data = CachedModel(name: auth_result.name, age: auth_result.age, password: auth_result.password)
                    self.write_cache_data(cache_data: cache_data)
                    DispatchQueue.main.async {
                        UIUtility.presentMainViewController(vc: self, cachedData: cache_data)
                    }
                } else {
                    Toast.show(message: "Не верный пароль!", view: view)
                }
            } else {
                Toast.show(message: "Такого пользователя не существует!", view: view)
            }
        }
    }

}
