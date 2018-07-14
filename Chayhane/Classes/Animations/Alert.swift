//
//  Alert.swift
//  Chayhane
//
//  Created by djepbarov on 13.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit

func newAlert(title: String, message: String, actionTitle: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
    alert.addAction(action)
    return alert
}

func newActionSheet(title: String, message: String, actionTitle: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
    let action = UIAlertAction(title: actionTitle, style: .default, handler: nil)
    alert.addAction(action)
    return alert
}
