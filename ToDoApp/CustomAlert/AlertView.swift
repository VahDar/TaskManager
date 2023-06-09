//
//  AlertView.swift
//  ToDoApp
//
//  Created by Vakhtang on 03.05.2023.
//

import UIKit

protocol AlertDelegate {
    func deleteButtonPressed()
    func saveButtonPressed()
    func switchButton(_ sender: UISwitch)
}

class AlertView: UIView {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var switchButton: UISwitch!
    @IBOutlet weak var deleteButton: AlertButton!
    @IBOutlet weak var saveButton: AlertButton!
    @IBOutlet weak var textField: UITextField!
    
    var delegate: AlertDelegate?
    var categoryCell: CategoryCollectionViewCell!
    var data: Category!
    var notificationCenter = UNUserNotificationCenter.current()
    
    //Mark: - Configure
    func configure() {
        datePicker.datePickerMode = .dateAndTime
        datePicker.date = Date()
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        datePicker.addTarget(self, action: #selector(doneAction), for: .valueChanged)
    }
    @objc func doneAction() {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        self.data.dayField = dayFormatter.string(from: self.datePicker.date)
        self.data.monthField = monthFormatter.string(from: self.datePicker.date)
        self.data.timeField = timeFormatter.string(from: self.datePicker.date)
    }
    
    // MARK: -  Notification
    func scheduleLocalNotification(){
        
        let notificationId = UUID().uuidString
        data.notificationId = notificationId
        //checking the notification setting whether it's authorized or not to send a request.
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            if settings.authorizationStatus == UNAuthorizationStatus.authorized{
                //1. create contents
                let content = UNMutableNotificationContent()
                content.title = "Complete your task"
                content.body = self.data.name ?? ""
                content.sound = UNNotificationSound.default
                //2. create trigger [calendar, timeinterval, location, pushnoti]
                
                let dateInfo = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute], from: self.datePicker.date)
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateInfo, repeats: false)
                //3. make a request
                let request = UNNotificationRequest(identifier: notificationId, content: content, trigger: trigger)
                self.notificationCenter.add(request) { (error) in
                    if error != nil{
                        print("error in notification! ")
                    }
                }
            }
            else {
                print("user denied")
            }
        }
        
    }

    @IBAction func switchButton(_ sender: UISwitch) {
        delegate?.switchButton(sender)
        
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteButtonPressed()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        delegate?.saveButtonPressed()
    }
    
}
