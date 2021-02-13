//
//  CalendarViewController.swift
//  eat_control
//
//  Created by marsel on 12.02.2021.
//

import UIKit

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var calendarView: CalendarView!
    @IBOutlet weak var table_view: UITableView!
    var list_items = [DataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.table_view.delegate = self
        self.table_view.dataSource = self
        let style = CalendarView.Style()
        
        calendarView.dataSource = self
        calendarView.delegate = self
        
        calendarView.direction = .horizontal
        calendarView.multipleSelectionEnable = false
        calendarView.marksWeekends = false
        
        
        if #available(iOS 13.0, *) {
            style.headerBackgroundColor    = UIColor.systemBackground
            style.weekdaysBackgroundColor  = UIColor.systemBackground
            calendarView.backgroundColor = UIColor.systemBackground
        } else {
            // Fallback on earlier versions
            style.headerBackgroundColor    = UIColor.white
            style.weekdaysBackgroundColor  = UIColor.white
            calendarView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        
        style.cellShape                = .bevel(8.0)
        style.cellColorDefault         = UIColor.clear
        style.cellColorToday           = UIColor(red:1.00, green:0.84, blue:0.64, alpha:1.00)
        style.cellSelectedBorderColor  = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.cellEventColor           = UIColor(red:1.00, green:0.63, blue:0.24, alpha:1.00)
        style.headerTextColor          = UIColor.gray
        
        style.cellTextColorDefault     = UIColor(red: 249/255, green: 180/255, blue: 139/255, alpha: 1.0)
        style.cellTextColorToday       = UIColor.orange
        style.cellTextColorWeekend     = UIColor(red: 237/255, green: 103/255, blue: 73/255, alpha: 1.0)
        style.cellColorOutOfRange      = UIColor(red: 249/255, green: 226/255, blue: 212/255, alpha: 1.0)
            
        
        style.firstWeekday             = .sunday
        
        style.locale                   = Locale(identifier: "ru_RU")
        
        style.cellFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.headerFont = UIFont(name: "Helvetica", size: 20.0) ?? UIFont.systemFont(ofSize: 20.0)
        style.weekdaysFont = UIFont(name: "Helvetica", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        
        calendarView.style = style
        
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list_items.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            
            cell.info_label.text = "Сахар в крови: \(sugar ?? "")\nВведено инсулина: \(insuline ?? "")\nЕда: \(eat ?? "")"
        }
        return cell
    }


}

extension CalendarViewController: CalendarViewDataSource {

      func startDate() -> Date {

          var dateComponents = DateComponents()
          dateComponents.month = -1

          let today = Date()

          let threeMonthsAgo = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!

          return threeMonthsAgo
      }

      func endDate() -> Date {

          var dateComponents = DateComponents()

          dateComponents.month = 12
          let today = Date()

          let twoYearsFromNow = self.calendarView.calendar.date(byAdding: dateComponents, to: today)!

          return twoYearsFromNow

      }

}

extension CalendarViewController: CalendarViewDelegate {
    
    func calendar(_ calendar: CalendarView, didSelectDate date : Date, withEvents events: [CalendarEvent]) {
//        print("Did Select: \(date) with \(events.count) events")
       let dateFormatter : DateFormatter = DateFormatter()
       dateFormatter.dateFormat = "dd.MM.yyyy"
       let currentDateString = dateFormatter.string(from: date)
//       print(currentDateString)
    //           for event in events {
    //               print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
    //           }
        self.list_items.removeAll()
        if let items = self.readItem() {
            for item in items {
                let itemDateString = dateFormatter.string(from: item.date)
                print(itemDateString)
                if itemDateString == currentDateString {
                    self.list_items.append(item)
                }
            }
            self.table_view.reloadData()
        }
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
       
   func calendar(_ calendar: CalendarView, didScrollToMonth date : Date) {
       print(self.calendarView.selectedDates)
   }
       
       
   func calendar(_ calendar: CalendarView, didLongPressDate date : Date, withEvents events: [CalendarEvent]?) {
       
       if let events = events {
           for event in events {
               print("\t\"\(event.title)\" - Starting at:\(event.startDate)")
           }
       }
       
       let alert = UIAlertController(title: "Create New Event", message: "Message", preferredStyle: .alert)
       
       alert.addTextField { (textField: UITextField) in
           textField.placeholder = "Event Title"
       }
       
       let addEventAction = UIAlertAction(title: "Create", style: .default, handler: { (action) -> Void in
           let title = alert.textFields?.first?.text
           //self.calendarView.addEvent(title!, date: date)
       })
       
       let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
       
       alert.addAction(addEventAction)
       alert.addAction(cancelAction)
       
       self.present(alert, animated: true, completion: nil)
       
   }
    
}
