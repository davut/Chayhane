//
//  AppControlViewController.swift
//  Chayhane
//
//  Created by djepbarov on 11.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Firebase

enum StoryboardID: String  {
    case loginVC = "login-view-controller"
    case mainVC = "tab-Bar-view-controller"
    case accountVC = "create-account-view-controller"
    case recSendVC = "receiver-sender-controller"
    case senderVC = "sender-view-controller"

}

enum ViewControllers: String {
    case senderVC = "sender-view-controller"
    case mainVC = "navigation-controller"
    case recSendVC = "receiver-sender-controller"
    case loginVC = "login-view-controller"
}

final class AppControlViewController: UIViewController {
    
    @IBOutlet weak var containerView: UIView!
    var actingVC: UIViewController!
    let apiService = APIService()
    override func viewDidLoad() {
        super.viewDidLoad()
        AppControlViewController.updateRootVC()
    }
    
}

// MARK: - Loading VC's
extension AppControlViewController {
    
    static func updateRootVC(){
        
        var rootVC : UIViewController?
        
        var id: StoryboardID = Auth.auth().currentUser?.uid != nil ? .mainVC : .loginVC
//        id = .loginVC
        let loginVC = ViewControllers.loginVC.rawValue
        //let recSendVC = ViewControllers.recSendVC.rawValue
        let mainVC = ViewControllers.mainVC.rawValue
        
        if(id == .mainVC){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: mainVC) as! UINavigationController
        }
        else {
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: loginVC) as! SignInViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
}
