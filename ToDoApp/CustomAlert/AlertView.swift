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
    
    func configureCell(with categoryCell: CategoryCollectionViewCell) {
        self.categoryCell = categoryCell
    }
    func configure() {
        datePicker.datePickerMode = .dateAndTime
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
        datePicker.addTarget(self, action: #selector(doneAction), for: .valueChanged)
    }
    @objc func doneAction() {
        getDateFromPicker()
//        datePicker.endEditing(true)
    }
    
    func getDateFromPicker() {
       
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "MMM"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
//        DispatchQueue.main.async {
//            self.categoryCell.setTexField(dayField: dayFormatter.string(from: self.datePicker.date), dayAndMonthField: dayAndMonthFormatter.string(from: self.datePicker.date), timeField: timeFormatter.string(from: self.datePicker.date))
//        }
        self.data.dayField = dayFormatter.string(from: self.datePicker.date)
        self.data.monthField = monthFormatter.string(from: self.datePicker.date)
        self.data.timeField = timeFormatter.string(from: self.datePicker.date)
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteButtonPressed()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        delegate?.saveButtonPressed()
    }
    
}
