//
//  ViewController.swift
//  Chayhane
//
//  Created by djepbarov on 9.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Firebase
import NVActivityIndicatorView

enum OrdersCell {
    case isHidden
    case isVisible
    case isInMax
}

class MenuViewController: UIViewController {
    
    
    let request = MyRequestController()
    
    var db : Firestore?
    let apiService = APIService()
    
    var ordersCell = OrdersCell.isHidden
    var items = [Item]()
    
    let loadView = UIView()
    var activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 300, height: 100), type: .ballTrianglePath, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), padding: 10)
    
    var userRole: String?
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var homeTableView: UITableView!
    
    var numberOfItem = 0
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if GlobalVariable.items.isEmpty {
            self.homeTableView.reloadSections(IndexSet(), with: UITableViewRowAnimation.middle)
            ordersCell = .isHidden
            containerView.frame = CGRect(x: 0, y: homeTableView.frame.maxY, width: view.frame.width, height: 550)
        }
        
        print("Container Veiw \(containerView.frame)")
    }
    
    func setupLoading() {
        loadView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        activityIndicator.startAnimating()
        loadView.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
        loadView.alpha = 0.8
        view.addSubview(loadView)
        activityIndicator.frame = CGRect(x: self.view.frame.midX - (activityIndicator.frame.width / 2), y: self.view.frame.midY - (activityIndicator.frame.height / 2), width: 100, height: 25)
        view.addSubview(activityIndicator)
    }
    
    func stopLoading() {
        UIView.animate(withDuration: 0.5, animations: {
            self.activityIndicator.stopAnimating()
            self.loadView.alpha = 0
        })
        
    }
    
    //TODO: Son halini hemen gorme (Realtime)
    //TODO: Secilenleri eksiltme
    //TODO: Signup'ta hatalar (token olusturamadi)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoading()
//        if #available(iOS 11.0, *) {
//            navigationController?.navigationBar.prefersLargeTitles = true
//            navigationItem.largeTitleDisplayMode = .always
//
//        } else {
//            // Fallback on earlier versions
//        }
        
        let token = InstanceID.instanceID().token()
        let uid = Auth.auth().currentUser?.uid
        print("uid", uid ?? "No uid")
        apiService.getDatas { (items) in
            self.items.removeAll()
            self.items = items
            self.stopLoading()
            self.homeTableView.reloadData()
        }
        
        func rightBarItem(for userRole: String) {
            if userRole == "Çaycı" {
                let rightBarItem = UIBarButtonItem(title: "Nöbetçiyim", style: .plain, target: self, action: #selector(senderRightBarTapped))
                navigationItem.rightBarButtonItem = rightBarItem
                let leftBarItem = UIBarButtonItem(title: "Güncelle", style: .plain, target: self, action: #selector(senderLeftBarTapped))
                navigationItem.leftBarButtonItem = leftBarItem
//                let leftMostBarItem = UIBarButtonItem(title: "Orders", style: .plain, target: self, action: nil)
//                navigationItem.leftBarButtonItems = [leftBarItem, leftMostBarItem]
            }
            else if userRole == "Hoca" {
                let rightBarItem = UIBarButtonItem(title: "Servis iste", style: .plain, target: self, action: #selector(receiverRightBarTapped))
                navigationItem.rightBarButtonItem = rightBarItem
            }
        }
        
        apiService.getCurrentUser { (userRole) in
            self.userRole = userRole
            rightBarItem(for: userRole)
            self.homeTableView.reloadData()
        }
        
        let nib = UINib(nibName: "ItemsTableViewCell", bundle: nil)
        homeTableView.register(nib, forCellReuseIdentifier: "cell")
        setupContainerView()
    }
    
    @objc func receiverRightBarTapped() {
        performSegue(withIdentifier: "toOrder", sender: nil)
    }
    
    @objc func senderRightBarTapped() {
        db = Firestore.firestore()
        let uid = Auth.auth().currentUser?.uid
        let name = Auth.auth().currentUser?.displayName
        let token = InstanceID.instanceID().token()
        db?.collection("duty").document("duty").setData(["name": name ?? "adim yok",
                                                         "token": token ?? "ops",
                                                         "uid": uid ?? "no uid"] )
    }
    
    @objc func senderLeftBarTapped() {
        db = Firestore.firestore()
        for item in items {
            guard let itemId = item.id else {return}
            db?.collection("products").document("\(itemId)").updateData(["numberOfItem": item.numberOfItem ?? 0], completion: { (err) in print(err?.localizedDescription ?? "No error I guess") })
        }
    }
    
    
    func setupContainerView() {
        containerView.layer.shadowOpacity = 0.3
        containerView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        containerView.layer.shadowRadius = 2
        containerView.layer.cornerRadius = 6
        
        //let tapGesture = UITapGestureRecognizer(target: self, action: #selector(containerTapped(gesture:)))
        //containerView.addGestureRecognizer(tapGesture)
        
        let upSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(containerSwiped(gesture:)))
        upSwipeGesture.direction = .up
        
        let downSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(containerSwiped(gesture:)))
        downSwipeGesture.direction = .down
        
        containerView.addGestureRecognizer(downSwipeGesture)
        containerView.addGestureRecognizer(upSwipeGesture)
    }
    
    @objc func containerSwiped(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .up:
            goUp()
        case .down:
            goDown()
        default:
            break
        }
    }
    
    func goUp() {
        if ordersCell == .isVisible {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.containerView.frame = CGRect(x: 0, y: self.view.frame.height - self.containerView.frame.height, width: self.containerView.frame.width, height: self.containerView.frame.height)
            })
            self.ordersCell = .isInMax
        }
    }
    
    func goDown() {
        if ordersCell == .isInMax {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.containerView.frame = CGRect(x: 0, y: self.view.frame.height - 70, width: self.containerView.frame.width, height: self.containerView.frame.height)
            })
            ordersCell = .isVisible
        }
    }
    
    func showUp() {
        if ordersCell == .isHidden {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.containerView.frame = CGRect(x: 0, y: self.containerView.frame.origin.y - 70, width: self.containerView.frame.width, height: self.containerView.frame.height)
            }) { (_) in
                
            }
        self.ordersCell = .isVisible
        }
    }
    
    @objc func containerTapped(gesture: UIGestureRecognizer) {
        switch ordersCell {
        case .isInMax:
            break
        case .isHidden:
            showUp()
        case .isVisible:
            goUp()
        }
        
    }
}


extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableViewCell
        cell.item = items[indexPath.row]
        if cell.item.numberOfItem == 0, userRole == "Hoca" {
            cell.label.isEnabled = false
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if userRole == "Hoca" {
            let selectedRow = tableView.indexPathForSelectedRow
            var selectedItem = items[(selectedRow?.row)!]
            homeTableView.reloadData()
//            if let numberOfItem = selectedItem.numberOfItem, !selectedItem.isDrink! {
//                selectedItem.numberOfItem! -= 1
//                selectedItem.numberOfOrder += 1
//                items[(selectedRow?.row)!] = selectedItem
//                homeTableView.reloadData()
//            }
//            else if selectedItem.isDrink! {
//                selectedItem.numberOfOrder += 1
//                items[(selectedRow?.item)!] = selectedItem
//                homeTableView.reloadData()
//            }
            switch ordersCell {
            case .isInMax:
                break
            case .isHidden:
                showUp()
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil, userInfo: ["item": selectedItem])
            case .isVisible:
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadTableView"), object: nil, userInfo: ["item": selectedItem, "selectedRow" : selectedRow?.row ?? 1])
            }
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if userRole == "Çaycı" {
        let plusAction: UITableViewRowAction = UITableViewRowAction(style: .default, title: "  ➕ \n arttır  ") { (action, indexPath) in
            if self.items[indexPath.row].isDrink! {
                if self.items[indexPath.row].numberOfItem! == 0 {
                    let numberOfItems = self.items[indexPath.row].numberOfItem! + 1
                    self.items[indexPath.row].numberOfItem = numberOfItems
                    self.homeTableView.reloadData()
                }
                else {
                    let alert = newAlert(title: "Var", message: "\(self.items[indexPath.row].label!) var kardeşim neyi arttırıyon", actionTitle: "A tamam")
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let numberOfItems = self.items[indexPath.row].numberOfItem! + 1
                self.items[indexPath.row].numberOfItem = numberOfItems
                self.homeTableView.reloadData()
            }
        }
        let minusAction: UITableViewRowAction = UITableViewRowAction(style: .default, title: "  ➖ \n eksilt  ") { (action, indexPath) in
            if self.items[indexPath.row].isDrink! {
                if self.items[indexPath.row].numberOfItem! == 1 {
                    let numberOfItems = self.items[indexPath.row].numberOfItem! - 1
                    self.items[indexPath.row].numberOfItem = numberOfItems
                    self.homeTableView.reloadData()
                }
                else {
                    let alert = newAlert(title: "Bitti", message: "\(self.items[indexPath.row].label!) bittmiş kardeşim neyi eksiltiyon", actionTitle: "A tamam")
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                if self.items[indexPath.row].numberOfItem! > 0 {
                    let numberOfItems = self.items[indexPath.row].numberOfItem! - 1
                    self.items[indexPath.row].numberOfItem = numberOfItems
                    self.homeTableView.reloadData()
                }
                else {
                    let alert = newAlert(title: "Bitti", message: "\(self.items[indexPath.row].label!) bitti kardeşim neyi eksiltiyon", actionTitle: "A tamam")
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
        
//        let endedAction: UITableViewRowAction = UITableViewRowAction(style: .default, title:  "  🙅🏻‍♂️ \n bitti  ") { (action, indexPath) in
//
//        }
        
        plusAction.backgroundColor = UIColor(red: 86.0/255.0, green: 195.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        minusAction.backgroundColor = UIColor(red: 76.0/255.0, green: 185.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        //endedAction.backgroundColor = UIColor(red: 66.0/255.0, green: 175.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        
        return [minusAction, plusAction]
        }
        else {
            return []
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as? OrderConfirmationViewController
        destinationVC?.items = self.items
    }
}
