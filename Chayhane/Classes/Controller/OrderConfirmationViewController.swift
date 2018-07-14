//
//  OrderConfirmationViewController.swift
//  Chayhane
//
//  Created by djepbarov on 9.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Firebase

class OrderConfirmationViewController: UIViewController {
    let request = MyRequestController()
    let apiService = APIService()
    @IBOutlet weak var submitBtn: UIButton!
    let blurEffectAnimations = BlurEffectAnimatoins()
    var db: Firestore?
    var items: [Item]?
    //var name: String?
    var token: String?
    var uid: String?
    @IBOutlet weak var whereToBtn: UIButton!
    var titles = ["23 Numara", "Lobi", "Muhasebe", "16", "19", "Personel odası", "Teras", "Fatih abi'nin odası", "Toplantı salonu", "Mütevelli"]
    @IBOutlet weak var pickerView: UIPickerView!
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        submitBtn.layer.cornerRadius = 6
    }
    @IBAction func whereToBtnPressed(_ sender: UIButton) {
        pickerView.isHidden = !pickerView.isHidden
    }
    @IBAction func sumbitBtnPressed(_ sender: UIButton) {
        
        UIView.animate(withDuration: 0.5) {
            self.submitBtn.isEnabled = false
            self.submitBtn.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        }
        var text = ""
        for i in GlobalVariable.items {
            text += "\(i.numberOfOrder) tane \(i.label ?? "bu ne"), "
        }
        
        
        guard text != "" else {
            blurEffectAnimations.animateCustomAlert(title: "Seçim yapmadınız", in: view) {
                self.submitBtn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                self.submitBtn.isEnabled = true
            }
            return
        }
        
        guard whereToBtn.titleLabel?.text != "Nereye?" else {
            blurEffectAnimations.animateCustomAlert(title: "Yer seçiniz", in: view) {
                self.submitBtn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                self.submitBtn.isEnabled = true
            }
            return
        }
        
        let name = Auth.auth().currentUser?.displayName

        
        //TODO: Hoca ismi gelmiyor
        
        apiService.getDuty { (nn, token, uid) in
            //self.name = name
            self.token = token
            self.uid = uid
            self.request.sendRequest(to: self.token ?? "", message: "\(text) - \(self.whereToBtn.titleLabel?.text ?? "Yer yok")", title: name ?? "Hoca", sound: "", selectedSound: "nil") { (M) in
                print(M)
            }
        }
        
        
        
        
        sendDataToFirestore(text: text)
    }
    
    func sendDataToFirestore(text: String) {
        db = Firestore.firestore()
        for (index, item) in (items?.enumerated())! {
            if item.label == items?[index].label, let itemsNumberOfItem = items?[index].numberOfItem {
                self.db?.collection("products").document(item.id!).updateData(["numberOfItem" : itemsNumberOfItem], completion: { (err) in
                    print(err?.localizedDescription)
                })
            }
        }
        
        
        let dataToFireStore: [String: String] = ["whereTo": "\(whereToBtn.titleLabel?.text! ?? "No Value")",
            "selectedItems" : text]
        db?.collection("orders").addDocument(data: dataToFireStore , completion: { (err) in
            if let err = err {
                self.blurEffectAnimations.animateCustomAlert(title: "Bir sorun var", in: self.view) {
                    self.submitBtn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                    self.submitBtn.isEnabled = true
                }
                print("ERROR uploading to Firestore: ", err.localizedDescription)
            }
            else {
                self.blurEffectAnimations.animateCustomAlert(title: "İsteğiniz alındı", in: self.view) {
                    self.submitBtn.backgroundColor = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
                    self.submitBtn.isEnabled = true
                }
                GlobalVariable.items = [Item]()
                print("Successfully uploaded")
            }
        })
        //TODO: Secilenleri onayladiktan sonra database'den sil
        //db?.collection("products").whereField("label", isEqualTo: GlobalVariable.items)
    }
}

extension OrderConfirmationViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return titles[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return titles.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        whereToBtn.setTitle(titles[row], for: .normal)
        pickerView.isHidden = true
    }

}
