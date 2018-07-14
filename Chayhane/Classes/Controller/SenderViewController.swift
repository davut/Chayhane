//
//  SenderViewController.swift
//  Chayhane
//
//  Created by djepbarov on 12.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit

class SenderViewController: UIViewController {

    @IBOutlet weak var homeTableView: UITableView!
    let apiService = APIService()
    var items = [Item]()
    override func viewDidLoad() {
        super.viewDidLoad()
        apiService.getDatas { (items) in
            self.items = items
            self.homeTableView.reloadData()
        }
        let nib = UINib(nibName: "ItemsTableViewCell", bundle: nil)
        homeTableView.register(nib, forCellReuseIdentifier: "cell")
    }

}

extension SenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableViewCell
        cell.item = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let plusAction: UITableViewRowAction = UITableViewRowAction(style: .default, title: "  ➕ \n arttır  ") { (action, indexPath) in
            let numberOfItems = self.items[indexPath.row].numberOfItem! + 1
            self.items[indexPath.row].numberOfItem = numberOfItems
        }
        let minusAction: UITableViewRowAction = UITableViewRowAction(style: .default, title: "  ➖ \n eksilt  ") { (action, indexPath) in
            let numberOfItems = self.items[indexPath.row].numberOfItem! - 1
            self.items[indexPath.row].numberOfItem = numberOfItems
        }
        
        let endedAction: UITableViewRowAction = UITableViewRowAction(style: .default, title:  "  🙅🏻‍♂️ \n bitti  ") { (action, indexPath) in
            
            }
        
        plusAction.backgroundColor = UIColor(red: 86.0/255.0, green: 195.0/255.0, blue: 210.0/255.0, alpha: 1.0)
        minusAction.backgroundColor = UIColor(red: 76.0/255.0, green: 185.0/255.0, blue: 200.0/255.0, alpha: 1.0)
        endedAction.backgroundColor = UIColor(red: 66.0/255.0, green: 175.0/255.0, blue: 190.0/255.0, alpha: 1.0)
        
        return [endedAction,  minusAction, plusAction]
    }

    
    
}
