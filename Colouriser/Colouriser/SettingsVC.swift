//
//  SettingVC.swift
//  Colouriser
//
//  Created by Group 1 on 1/1/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var updateTypeOfColourblindnessButton: UIButtonX!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerData: [String] = [String]()
    var typeOfColourblindnessChosen: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pickerView.delegate = self
        self.pickerView.dataSource = self
        
        pickerData = ["Select type of colourblindness: ", "protanopia", "deuteranopia"]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected: \(pickerData[row])")
        
        typeOfColourblindnessChosen = pickerData[row]
    }
    
    @IBAction func updateTypeOfColourblindness(_ sender: Any) {
        UserDefaults.standard.set(typeOfColourblindnessChosen, forKey: "typeOfColourblindness")
        
        performSegue(withIdentifier: "backToHome", sender: self)
    }
    
}
