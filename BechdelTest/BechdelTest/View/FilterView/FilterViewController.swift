//
//  FilterViewController.swift
//  BechdelTest
//
//  Created by Gabriel Ferreira on 04/09/20.
//  Copyright © 2020 Ribeiro Ferreira. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var fromPicker: UIPickerView!
    @IBOutlet weak var toPicker: UIPickerView!
    @IBOutlet weak var ratingPicker: UIPickerView!
    
    var years: [Int]!
    var ratings: [String] = ["all",
                            "no two women",
                            "two women, no talking",
                            "two women talking about a man",
                            "passes the test"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fromPicker.delegate = self
        self.toPicker.delegate = self
        self.ratingPicker.delegate = self
        self.searchField.delegate = self
        
        self.fromPicker.dataSource = self
        self.toPicker.dataSource = self
        self.ratingPicker.dataSource = self
        
        self.toPicker.selectRow(years.count - 1, inComponent: 0, animated: false)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == fromPicker || pickerView == toPicker {
            return self.years.count
        } else {
            return self.ratings.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == fromPicker || pickerView == toPicker {
            return self.years[row].description
        } else {
            return self.ratings[row]
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
    }
    
    @IBAction func applyFilter(_ sender: Any) {
        fromYear = years[self.fromPicker.selectedRow(inComponent: 0)]
        toYear = years[self.toPicker.selectedRow(inComponent: 0)]
        rating = self.ratingPicker.selectedRow(inComponent: 0) == 0 ? nil : self.ratingPicker.selectedRow(inComponent: 0) - 1
        search = self.searchField.text
        
        self.dismiss(animated: true, completion: nil)
    }
}
