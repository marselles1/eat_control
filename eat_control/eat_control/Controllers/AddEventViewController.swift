//
//  AddEventViewController.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import UIKit

class AddEventViewController: UIViewController {

    @IBOutlet weak var time_label: UILabel!
    
    @IBOutlet weak var sugar_field: UITextField!
    @IBOutlet weak var insuline_field: UITextField!
    @IBOutlet weak var eat_field: UITextField!
    
    @IBOutlet weak var sugar_switch: UISwitch!
    @IBOutlet weak var insuline_switch: UISwitch!
    @IBOutlet weak var eat_switch: UISwitch!
    
    
    var list_items = [DataModel]()
    var id: Int!
    var date: Date!
    
    @objc func textFieldDidChange(textField: UITextField){
        let limit = 15;
        if textField.text!.count > limit {
            textField.text = String(textField.text!.prefix(limit))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addObservers()
        self.date = Date()
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let itemDateString = dateFormatter.string(from: self.date)
        self.time_label.text = itemDateString
        self.sugar_field.inputAccessoryView = self.getToolbar()
        self.insuline_field.inputAccessoryView = self.getToolbar()
        self.eat_field.inputAccessoryView = self.getToolbar()
        self.sugar_field.addTarget(self, action: #selector(sugarFieldDidChange(textField:)), for: .editingChanged)
        if let items = self.readItem() {
            self.list_items = items
        }
        self.id = self.list_items.count
        self.insuline_field.addTarget(self, action: #selector(textFieldDidChange(textField:)), for: .editingChanged)
    }
    
    func addObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {return}
        let keyboardFrame = keyboardSize.cgRectValue

        if self.view.bounds.origin.y == 0{
            self.view.bounds.origin.y += keyboardFrame.height / 1.7
        }
    }

    @objc func keyboardWillHide(_ notification: NSNotification) {
        if self.view.bounds.origin.y != 0 {
            self.view.bounds.origin.y = 0
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.saveChanges()
    }
    
    func existChanges() -> Bool {
        if self.sugar_field.text != "" || self.insuline_field.text != "" || self.eat_field.text != "" {
            return true
        }
        return false
    }
    
    func saveChanges() {
        if self.existChanges() {
            var sugar: String!
            var insuline: String!
            var eat: String!
            
            if !sugar_switch.isOn {
                sugar = "пусто"
            } else {
                sugar = self.sugar_field.text ?? ""
            }
            
            if !insuline_switch.isOn {
                insuline = "пусто"
            } else {
                insuline = self.insuline_field.text ?? ""
            }
            
            if !eat_switch.isOn {
                eat = "пусто"
            } else {
                eat = self.eat_field.text ?? ""
            }
            self.list_items.append(DataModel(id: self.id, date: date, sugar: sugar, insulin: insuline, eat: eat))
            Storage.writeData(json_data: self.list_items)
        }
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
    
    @objc func sugarFieldDidChange(textField: UITextField){
        let limit = 60;
        if textField.text!.count > limit {
            textField.text = String(textField.text!.prefix(limit))
        }
    }
    
    func removeItem(id: Int) {
        var json_data: [DataModel]?
        json_data = self.readItem()
        print("Remove item from json...")
        json_data?.removeAll(where: {$0.id == id})
        Storage.writeData(json_data: json_data)
    }
    
    func readItem() -> [DataModel]? {
        var json_data: [DataModel]?
        let file_name = "data.json"
        do {
            print("Read json data...")
            json_data = try Storage.retrieve(file_name, from: .documents, as: [DataModel].self)
            print(json_data)
        } catch {
            print(error.localizedDescription)
        }
        return json_data
    }
    
}
