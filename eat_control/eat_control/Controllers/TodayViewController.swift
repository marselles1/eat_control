//
//  TodayViewController.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import UIKit

class TodayViewController: UITableViewController {
    
    @IBOutlet var table_view: UITableView!
    
    var list_items = [DataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let dateFormatter : DateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd.MM.yyyy"
        let date = Date()
        let dateString = dateFormatter.string(from: date)
        self.navigationItem.title = "Сегодня \(dateString)"
    }

    override func viewDidAppear(_ animated: Bool) {
        if let items = self.readItem() {
            self.list_items = items
        }
        self.table_view.reloadData()
    }
    
    @IBAction func BtnAddClicked(_ sender: UIBarButtonItem) {
        UIUtility.showPageViewController(vc: self, identifier: Constants.addEventViewController)
//        UIUtility.showAddEventViewController(vc: self)
    }
    
    func readItem() -> [DataModel]? {
        var json_data: [DataModel]?
        let file_name = "data.json"
        do {
            print("Read json data...")
            json_data = try Storage.retrieve(file_name, from: .documents, as: [DataModel].self)
        } catch {
            print(error.localizedDescription)
        }
        return json_data
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! TodayTableViewCell
        if self.list_items.count > 0 {
            let item = self.list_items[indexPath.row]
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: item.date)
            let minutes = calendar.component(.minute, from: item.date)
            cell.time_label.text = "\(hour):\(minutes)"
            
            var sugar: String!
            var insuline: String!
            var eat: String!
            
            sugar = item.sugar ?? ""
            
            if item.insulin != "пусто" {
                insuline = "\(item.insulin ?? "") ед."
            } else {
                insuline = item.insulin ?? ""
            }
            
            if item.eat != "пусто" {
                eat = "\(item.eat ?? "") ХЕ."
            } else {
                eat = item.eat ?? ""
            }
            
            cell.info_label.text = "Уровень сахара в крови: \(sugar ?? "")\nВведено инсулина: \(insuline ?? "")\nЕда: \(eat ?? "")"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.list_items.remove(at: indexPath.row)
            self.table_view.reloadData()
            Storage.writeData(json_data: self.list_items)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

}
