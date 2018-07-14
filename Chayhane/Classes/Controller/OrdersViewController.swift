//
//  OrdersViewController.swift
//  Chayhane
//
//  Created by djepbarov on 9.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit

struct GlobalVariable {
    static var items = [Item]()
}

class OrdersViewController: UIViewController{
    
    //var items = [Item]()
    
    @IBOutlet weak var ordersTableView: UITableView!
    var numberOfItem = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "OrdersTableViewCell", bundle: nil)
        ordersTableView.register(nib, forCellReuseIdentifier: "cell")
        NotificationCenter.default.addObserver(self, selector: #selector(reloadTableView(_:)), name: NSNotification.Name(rawValue: "reloadTableView"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        ordersTableView.reloadData()
    }
    
    
    @objc func reloadTableView(_ notification: NSNotification) {
        var item: Item?
        if let selectedItem = notification.userInfo?["item"] as? Item {
            item = selectedItem
            if GlobalVariable.items.count > 0 {
                var isNewItem = true
                for (index, exactItem) in GlobalVariable.items.enumerated() {
                    if exactItem.label == item?.label {
                        GlobalVariable.items[index].numberOfOrder += 1
                        let getRemoved = GlobalVariable.items.remove(at: index)
                        GlobalVariable.items.insert(getRemoved, at: 0)
                        ordersTableView.reloadData()
                        isNewItem = false
                        return
                    }
                }
                if isNewItem {
                    item?.numberOfOrder += 1
                    GlobalVariable.items.insert(item!, at: 0)
                    ordersTableView.reloadData()
                    //ordersTableView.reloadSections(IndexSet(), with: .automatic)
                    return
                }
            }
            else {
                item?.numberOfOrder += 1
                GlobalVariable.items.insert(item!, at: 0)
                ordersTableView.reloadData()
                //ordersTableView.reloadSections(IndexSet(), with: .automatic)
            }
        }
    }
}

extension OrdersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return GlobalVariable.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ordersTableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrdersTableViewCell
        cell.item = GlobalVariable.items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {        
//        let selectedIndexpath = tableView.indexPathForSelectedRow
//        let selectedItem = GlobalVariable.items[(selectedIndexpath?.row)!]
//        if selectedItem.numberOfOrder > 1 {
//
//            GlobalVariable.items[(selectedIndexpath?.row)!].numberOfOrder -= 1
//        }
//        else if selectedItem.numberOfOrder <= 1 {
//            GlobalVariable.items.remove(at: (selectedIndexpath?.row)!)
//        }
//        self.ordersTableView.reloadData()
//
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
}
