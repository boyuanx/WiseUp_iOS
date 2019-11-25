//
//  StoreItemDetailsViewController.swift
//  QuickFin
//
//  Created by Boyuan Xu on 10/28/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SwiftMessages
import Bond

class StoreItemDetailsViewController: BaseViewController {
    
    var buyButton: UIButton?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var item: StoreItem! {
        didSet {
            initUI(image: FirebaseService.shared.getImage(URL: self.item.imageName), title: self.item.name, details: self.item.details, cost: self.item.cost)
        }
    }
    
}

extension StoreItemDetailsViewController {
    
    func buyItem() {
        
        if !UserShared.shared.avatarsOwned.contains(item.name) {
            
            //  check if user has enough funds to purchase
            
            UserShared.shared.avatarsOwned.append(item.name)
            FirebaseService.shared.pushUserToFirebase()
            
            buyButton!.setTitle("Already Owned".localized(), for: .normal)
            
            let prompt: MessageView = {
                let mv = MessageView.viewFromNib(layout: .cardView)
                mv.configureTheme(.success)
                mv.configureDropShadow()
                mv.configureContent(title: "Success".localized(), body: "Would you like to equip this avatar?".localized())  // Error messages are typically pre-localized
                mv.button?.setTitle("Yes".localized(), for: .normal)
                _ = mv.button?.reactive.tap.observeNext(with: { [unowned self] (_) in
                    UserShared.shared.avatar = self.item.name
                    SwiftMessages.hide()
                    self.dismiss(animated: true, completion: nil)
                })
                return mv
            }()
            var config = SwiftMessages.Config()
            config.presentationContext = .window(windowLevel: .statusBar)
            config.preferredStatusBarStyle = .lightContent
            SwiftMessages.show(config: config, view: prompt)
        }
        
    }
    
}
