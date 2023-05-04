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
    
    var delegate: AlertDelegate?
    
    private var categoryCell: CategoryCollectionViewCell?
    
    func configure() {
        datePicker.datePickerMode = .dateAndTime
        let localeID = Locale.preferredLanguages.first
        datePicker.locale = Locale(identifier: localeID!)
    }
    
    func getDateFromPicker() {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "dd"
        let dayAndMonthFormatter = DateFormatter()
        dayAndMonthFormatter.dateFormat = "E MMM"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        categoryCell!.setTexField(dayField: dayFormatter.string(from: datePicker.date), dayAndMonthField: dayAndMonthFormatter.string(from: datePicker.date), timeField: timeFormatter.string(from: datePicker.date))
    }
    
    @IBAction func deleteButtonPressed(_ sender: Any) {
        delegate?.deleteButtonPressed()
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        getDateFromPicker()
        delegate?.saveButtonPressed()
    }
    
    
    
}
