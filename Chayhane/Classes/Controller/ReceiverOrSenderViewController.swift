//
//  ReceiverOrSenderViewController.swift
//  Chayhane
//
//  Created by djepbarov on 12.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Firebase

final class ReceiverOrSenderViewController: UIViewController {
    
    var actingVC: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReceiverOrSenderViewController.updateRootVC()
        
    }
    
}

// MARK: - Loading VC's
extension ReceiverOrSenderViewController {
    
    static func updateRootVC(){
        
        var rootVC : UIViewController?
        let apiService = APIService()
        var userRole: String?
   
        var id: StoryboardID!
        
        
        func waitForUser() {
            if userRole == "Çaycı" {
                id = .senderVC
            }
            else if userRole == "Hoca" {
                id = .mainVC
            }
            else {
            }
        }
        
        apiService.checkUser(successCallback: { (who) in
            userRole = who
            waitForUser()
            openVC()
        })
        
        func openVC() {
            let senderVC = ViewControllers.senderVC.rawValue
            let mainVC = ViewControllers.mainVC.rawValue
            let recSendVC = ViewControllers.recSendVC.rawValue
            
            if(id == .mainVC){
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: mainVC) as! UINavigationController
            }
                
            //
            else if id == .senderVC {
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: mainVC) as! UINavigationController
            }
                
            else {
                rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: recSendVC) as! ReceiverOrSenderViewController
            }
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = rootVC
        }
        
        
    }
}

