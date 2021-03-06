//
//  AchievementMessageHandler.swift
//  QuickFin
//
//  Created by Connor Buckley on 11/12/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import SwiftMessages
import Localize_Swift

class AchievementMessageHandler {
    
    static var shared = AchievementMessageHandler()
    private init() {}
    
    private func getView(theme: Theme, title: String, body: String, buttonTitle: String? = nil) -> MessageView {
        let errorView = MessageView.viewFromNib(layout: .cardView)
        errorView.configureTheme(theme)
        errorView.configureDropShadow()
        errorView.configureContent(title: title.localized(), body: body)  // Error messages are typically pre-localized
        if let buttonTitle = buttonTitle {
            errorView.button?.setTitle(buttonTitle.localized(), for: .normal)
        } else {
            errorView.button?.setTitle("Okay".localized(), for: .normal)
        }
        _ = errorView.button?.reactive.tap.observeNext(with: { (_) in
            SwiftMessages.hide()
        })
        return errorView
    }
    
    func showMessage(theme: Theme, title: String, body: String, buttonTitle: String? = nil) {
        let errorView = getView(theme: theme, title: title, body: body, buttonTitle: buttonTitle)
        SwiftMessages.show(view: errorView)
    }
    
    func showMessageModal(theme: Theme, title: String, body: String, buttonTitle: String? = nil) {
        let errorView = getView(theme: theme, title: title, body: body, buttonTitle: buttonTitle)
        var config = SwiftMessages.Config()
        config.presentationContext = .window(windowLevel: .statusBar)
        config.preferredStatusBarStyle = .lightContent
        SwiftMessages.show(config: config, view: errorView)
    }
    
}

