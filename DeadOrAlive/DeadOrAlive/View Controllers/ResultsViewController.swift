//
//  ResultsViewController.swift
//  DeadOrAlive
//
//  Created by morse on 1/3/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class ResultsViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var newHighLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    
    
    // MARK: - Properties
    
    var gameController: GameController?
    var networkController: NetworkController?
    var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func startNewGame(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViews() {
        
        newHighLabel.isHidden = true
        rankLabel.isHidden = true
        
        guard let gameController = gameController else { return }
        
        resultLabel.text = "\(gameController.numberRight) correct out of \(gameController.totalAnswered)"
        remainingTimeLabel.text = "\(String(Int(gameController.totalRemainingTime.rounded()))) Seconds"
        totalScoreLabel.text = numberFormatter.string(from: NSNumber(value: gameController.getScore(for: gameController.gameLevel)))
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == PropertyKeys.signUpSegue {
            guard let signUpVC = segue.destination as? SignUpViewController,
            let gameController = gameController else { return }
            signUpVC.hasResults = true
            signUpVC.score = gameController.getScore(for: gameController.gameLevel)
            signUpVC.time = gameController.totalRemainingTime
            signUpVC.networkController = networkController
        }
    }
}
