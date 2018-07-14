//
//  BlurEffectAnimations.swift
//  Chayhane
//
//  Created by djepbarov on 10.07.2018.
//  Copyright © 2018 chayhane. All rights reserved.
//

import UIKit

class BlurEffectAnimatoins {
    func animateCustomAlert(title: String, in view: UIView, completion: @escaping ()->()) {
        let blurEffect = UIBlurEffect(style: .dark)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        let blurEffectLbl = UILabel()
        blurEffectLbl.font = UIFont.boldSystemFont(ofSize: 16)
        blurEffectLbl.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        blurEffectLbl.textAlignment = .center
        blurEffectLbl.frame = CGRect(x: 10, y: visualEffectView.frame.midY - 10, width: 140, height: 20)
        blurEffectLbl.center = view.center
        
        visualEffectView.clipsToBounds = true
        print(blurEffectLbl.frame)
        visualEffectView.frame = CGRect(x: view.center.x - 75, y: view.center.y - 75, width: 150, height: 150)
        visualEffectView.layer.cornerRadius = 6
        view.addSubview(visualEffectView)
        view.addSubview(blurEffectLbl)
        let animator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7, animations: {
            blurEffectLbl.text = title
            blurEffectLbl.alpha = 1
            visualEffectView.alpha = 1
        })
        animator.startAnimation()
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            let closeAnimator = UIViewPropertyAnimator(duration: 0.7, dampingRatio: 0.7, animations: {
                visualEffectView.alpha = 0
                blurEffectLbl.alpha = 0
                completion()
            })
            closeAnimator.startAnimation()
        }
    }
}
