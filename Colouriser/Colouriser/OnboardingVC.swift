//
//  OnboardingVC.swift
//  Colouriser
//
//  Created by Walter Bassage on 27/01/2018.
//  Copyright © 2018 Mark Moeykens. All rights reserved.
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
}
