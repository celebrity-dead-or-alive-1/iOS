//
//  QuestionViewController.swift
//  DeadOrAlive
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

class QuestionViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var timeWordLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var deadButton: UIButton!
    @IBOutlet weak var aliveButton: UIButton!
    
    
    // MARK: - Properties
    
    let gameController = GameController()
//    var gameController: GameController?
    var celebrity: Celebrity?// {
//        return gameController?.getRandomCelebrity()
//    }
    var totalQuestions: Int?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        setTotalQuestions()
        celebrity = gameController.getRandomCelebrity()
        updateViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        shouldDismiss()
    }
    
    func shouldDismiss() {
        if gameController.testCelebrities == [] {
            
            timeWordLabel.isHidden = true
            levelLabel.isHidden = true
            numberLabel.isHidden = true
            timeLabel.isHidden = true
            imageView.isHidden = true
            nameLabel.isHidden = true
            deadButton.isHidden = true
            aliveButton.isHidden = true
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func updateViews() {
        guard let celebrity = celebrity/*,
            let level = gameController?.gameLevel.rawValue,
            let answeredQuestions = gameController?.totalAnswered*/else { return }
        
        if let imagedata = gameController.celebrityPhotosData[celebrity.id] {
            imageView.image = UIImage(data: imagedata)
        }
        levelLabel.text = gameController.gameLevel.rawValue// level
        numberLabel.text = "\(gameController.totalAnswered/*answeredQuestions*/ + 1)/\(totalQuestions ?? 0)"
        timeLabel.text = "N/A"
        
        nameLabel.text = celebrity.name
    }
    
    // MARK: - Actions
    
    @IBAction func answerTapped(_ sender: UIButton) {
        guard let celebrity = celebrity else { return }
        let answer: AnswerType = sender == deadButton ? .dead : .alive
        
        displayResult(for: gameController.checkAnswer(answer, for: celebrity))
//        if let correct = gameController?.checkAnswer(answer, for: celebrity) {
//            displayResult(for: correct)
//        }
    }
    
    // MARK: - Private
    
    private func setTotalQuestions() {
        totalQuestions = gameController.testCelebrities.count
    }
    
    private func displayResult(for correct: Bool) {
        switch correct {
        case true:
            // green overlay with "ok" button
            print("Correct!")
        case false:
            // red overlay with "ok" button
            print("Wrong!")
        }
        
        if gameController.gameStatus == .active {
            celebrity = gameController.getRandomCelebrity()
            updateViews()
        } else {
            performSegue(withIdentifier: PropertyKeys.restultsSegue, sender: nil)
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let resultVC = segue.destination as? ResultsViewController else { return }
        resultVC.gameController = gameController
    }
    

}
