//
//  GameViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit

protocol GameDelegate: class {
    func proceedToNextVC()
}

class GameViewController: BaseViewController, GameDelegate {
    
    var chapterName: String?
    var answered = false
    var attempts = 0
    var skipped = 0
    var total = 0
    var points: Int!
    var questionNumber: Int!
    var questions: [Question]!
    var currentQuestion: Question!
    let reuseID = "game"
    var tableView: UITableView!
    var questionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        if getCurrentQuestion() {
            initNav()
            initTableView()
            initUI()
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if answered {
            navigationItem.hidesBackButton = true
            navigationItem.setLeftBarButton(UIBarButtonItem(title: "Chapters".localized(), style: .plain, target: self, action: #selector(popToRootVC)), animated: true)
            navigationItem.rightBarButtonItem?.title = "Next"
        } else {
            navigationItem.hidesBackButton = false
            navigationItem.leftBarButtonItem = nil
            navigationItem.rightBarButtonItem?.title = "Skip"
        }
        navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func getCurrentQuestion() -> Bool {
        if questions.count == 0 {
            MessageHandler.shared.showMessage(theme: .error, title: Text.Error, body: Text.SomethingWentWrong)
            return false
        } else {
            currentQuestion = questions[questionNumber-1]
            return true
        }
    }
    
    @objc func skip() {
        attempts += 1
        skipped += 1
        proceedToNextVC()
    }
    
    func proceedToNextVC() {
        tableView.isUserInteractionEnabled = false
        calculatePoints()
        
        //if this is the last question, go to the results view controller
        if questionNumber == questions.count {
            let nextVC = ResultsViewController()
            nextVC.points = points
            nextVC.attempts = attempts
            nextVC.total = questions.count
            nextVC.skipped = skipped
            nextVC.chapterName = chapterName
            nextVC.navigationItem.hidesBackButton = true
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = GameViewController()
            nextVC.points = points + 100
            nextVC.questionNumber = questionNumber + 1
            nextVC.questions = questions
            nextVC.attempts = attempts
            nextVC.chapterName = chapterName
            navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    @objc func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func calculatePoints() {
        if (questionNumber == 1) {
            points = 100
        }
    }
    
}


