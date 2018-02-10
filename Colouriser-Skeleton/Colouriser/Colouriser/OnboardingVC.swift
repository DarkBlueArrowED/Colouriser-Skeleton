//
//  OnboardingVC.swift
//  Colouriser
//
//  Created by Group 1 on 1/1/18.
//  Copyright © 2018 Group 1. All rights reserved.
//

import UIKit

class OnboardingVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField!

    override func viewDidLoad() {
        nameTextField.delegate = self
        super.viewDidLoad()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (nameTextField.text?.isEmpty)!  {
            return false
        }
        return true
    }
    @IBAction func continueClicked(_ sender: UIButton) {
        UserDefaults.standard.set(nameTextField.text, forKey: "name")
        performSegue(withIdentifier: "toMainSegue", sender: self)
    }
}
