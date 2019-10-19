//
//  GameViewController.swift
//  QuickFin
//
//  Created by Connor Buckley on 10/14/19.
//  Copyright © 2019 Fidelity Investments. All rights reserved.
//

import UIKit
import Localize_Swift

class GameViewController: BaseViewController {
    
    var answered = false
    var attempts = 0
    var points = 0
    var questionNumber: Int!
    var questions: [Question]!
    var currentQuestion: Question!
    let reuseID = "game"
    var tableView: UITableView!
    var questionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentQuestion()
        initNav()
        initTableView()
        initUI()
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
    
    func getCurrentQuestion() {
        currentQuestion = questions[questionNumber-1]
    }
    
    @objc func proceedToNextVC() {
        tableView.isUserInteractionEnabled = false
        calculatePoints()
        if questionNumber == questions.count {
            let nextVC = ResultsViewController()
            nextVC.points = points
            navigationController?.pushViewController(nextVC, animated: true)
        } else {
            let nextVC = GameViewController()
            nextVC.points = points
            nextVC.questionNumber = questionNumber + 1
            nextVC.questions = questions
            navigationController?.pushViewController(nextVC, animated: true)
            print("ttttt")
        }
    }
    
    @objc func popToRootVC() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func calculatePoints() {
        #warning("TODO: Implementation")
    }
    
}


