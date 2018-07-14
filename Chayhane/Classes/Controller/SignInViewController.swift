//
//  SignInViewController.swift
//  Chayhane
//
//  Created by djepbarov on 11.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {

    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var roleBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    var roles = ["Çaycı", "Hoca"]
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
    }
    @IBAction func roleBtnPressed(_ sender: UIButton) {
        pickerView.isHidden = false
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) { (authUser, err) in
            if let err = err {
                print(err.localizedDescription)
            }
            if authUser != nil {
                self.performSegue(withIdentifier: "toMenu", sender: nil)
//                if self.roleBtn.titleLabel?.text == "Çaycı" {
//                    self.performSegue(withIdentifier: "toSender", sender: nil)
//                }
//                else if self.roleBtn.titleLabel?.text == "Hoca" {
//                    self.performSegue(withIdentifier: "toMenu", sender: nil)
//                }
//                else {
//                    let alertController = UIAlertController(title: "Hoca mısınız yoksa Çaycı?", message: "Lütfen seçin", preferredStyle: .alert)
//                    let action = UIAlertAction(title: "Tamam", style: .default, handler: nil)
//                    alertController.addAction(action)
//                    self.present(alertController, animated: true, completion: nil)
//                }
            }
        }
    }
}

extension SignInViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return roles[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return roles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        roleBtn.setTitle(roles[row], for: .normal)
        //signUpBtn.isHidden = false
        pickerView.isHidden = true
    }
}
