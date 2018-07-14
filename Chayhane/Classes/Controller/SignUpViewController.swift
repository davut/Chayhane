//
//  SignUpViewController.swift
//  Chayhane
//
//  Created by djepbarov on 10.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {

    @IBOutlet weak var nameSurnameTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var passwordAgainTextfield: UITextField!
    @IBOutlet weak var roleBtn: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var signUpBtn: UIButton!
    let animations = BlurEffectAnimatoins()
    var db : Firestore?
    var roles = ["Çaycı", "Hoca"]
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Auth.auth().addStateDidChangeListener { auth, user in
            
            if (user != nil && auth.currentUser != nil)
            {
                self.performSegue(withIdentifier: "toMenu", sender: nil)
            }
        }
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    @IBAction func roleBtnPressed(_ sender: UIButton) {
        pickerView.isHidden = !pickerView.isHidden
        signUpBtn.isHidden = true
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        guard let nameSurname = nameSurnameTextfield.text, let email = emailTextfield.text, let password = passwordTextfield.text, let passwordAgain = passwordAgainTextfield.text, let role = roleBtn.titleLabel?.text, roleBtn.titleLabel?.text != "Kimsiniz?" else {
            animations.animateCustomAlert(title: "Tekrar bak", in: view) {
                
            }
            return
        }
        db = Firestore.firestore()
        guard password == passwordAgain else {
            animations.animateCustomAlert(title: "Şifreler uymuyor", in: view) {
                
            }
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if let error = error {
                print(error.localizedDescription)
                self.animations.animateCustomAlert(title: "Bir sorun oluştu", in: self.view, completion: {
                    
                })
            }
            else {
                let uid = Auth.auth().currentUser?.uid
                let userInfos = ["uid" : uid ?? "no uid",
                                 "nameSurname" : nameSurname,
                                 "email" : email,
                                 "role" : role ]
                self.db?.collection("users").addDocument(data: userInfos, completion: { (err) in
                    if let err = err {
                        self.animations.animateCustomAlert(title: "Bir sorun oluştu", in: self.view, completion: {
                            
                        })
                        print(err.localizedDescription)
                    }
                    else {
                        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                        changeRequest?.displayName = nameSurname
                        changeRequest?.commitChanges { (error) in
                            print(err?.localizedDescription)
                        }
                        self.animations.animateCustomAlert(title: "Hoş geldiniz", in: self.view, completion: {
                            if role == "Hoca"{
                                self.performSegue(withIdentifier: "toMenu", sender: nil)
                            }
                            else if role == "Çaycı" {
                                self.performSegue(withIdentifier: "toSender", sender: nil)
                            }
                            
                        })
                    }
                })
            }
        }
        
        
    }
}

extension SignUpViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        signUpBtn.isHidden = false
        pickerView.isHidden = true
    }

    
}
