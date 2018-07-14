//
//  OrdersTableViewCell.swift
//  Chayhane
//
//  Created by djepbarov on 9.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit

class OrdersTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var objectImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    var numberOfItem = 0
    var item: Item! {
        didSet{
            label.text = "\(item.numberOfOrder) tane \(item.label!)"
            guard let image = item.image else {return}
            if let imageUrl = URL(string: image) {
                objectImageView.kf.setImage(with: imageUrl)
            }
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
