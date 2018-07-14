//
//  OrdersTableViewCell.swift
//  Chayhane
//
//  Created by djepbarov on 9.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit
import Kingfisher

class ItemsTableViewCell: UITableViewCell {

    @IBOutlet weak var objectImageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var numberOfItemLbl: UILabel!
    @IBOutlet weak var numberOfOrderBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    var item: Item! {
        didSet {
            if let numberOfItem = item.numberOfItem, !item.isDrink! {
                numberOfItemLbl.text = "\(numberOfItem) tane \(item.label!)"
                if numberOfItem == 0 {
                    numberOfItemLbl.text = "Bitti"
                }
            }
            else if item.isDrink! {
                if item.numberOfItem == 1 {
                    numberOfItemLbl.text = "Var"
                }
                else if item.numberOfItem == 0 {
                    numberOfItemLbl.text = "Bitti"
                }
                
                
            }
            numberOfOrderBtn.setTitle("\(item.numberOfOrder)", for: .normal)
            
            label.text = item.label
            guard let image = item.image else {return}
            if let imageUrl = URL(string: image) {
                objectImageView.kf.setImage(with: imageUrl)
            }
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func numberOfOrderBtnPressed(_ sender: UIButton) {
        item.numberOfOrder -= 1
        item.numberOfItem! += 1
        print(item.numberOfOrder)
    }
    
    
}
