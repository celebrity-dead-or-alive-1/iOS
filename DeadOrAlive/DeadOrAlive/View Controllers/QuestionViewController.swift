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
    @IBOutlet weak var correctFilterView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: - Properties
    
    let gameController = GameController()
    let countdown = Countdown()
    var networkController: NetworkController?
    var celebrity: Celebrity?
    var user: User?
    var gameLevel = ""
    var totalQuestions: Int?
    var startTime = CACurrentMediaTime()
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "s.S"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        GameController. =
        countdown.duration = 5
        countdown.delegate = self
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
            correctFilterView.isHidden = true
            continueButton.isHidden = true
            
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    
    func updateViews() {
        
        correctFilterView.isHidden = true
        continueButton.isHidden = true
        
        guard let celebrity = celebrity/*,
            let level = gameController?.gameLevel.rawValue,
            let answeredQuestions = gameController?.totalAnswered*/else { return }
        
        setImage(for: celebrity)
        
        if let imagedata = gameController.celebrityPhotosData[Int(celebrity.id)] {
            imageView.image = UIImage(data: imagedata)
        }
        levelLabel.text = gameLevel// level
        numberLabel.text = "\(gameController.totalAnswered/*answeredQuestions*/ + 1)/\(totalQuestions ?? 0)"
        nameLabel.text = celebrity.name
        
        countdown.start()
    }
    
    private func string(from duration: TimeInterval) -> String {
        let date = Date(timeIntervalSinceReferenceDate: duration)
        return dateFormatter.string(from: date)
    }
    
    
    func setImage(for celebrity: Celebrity) {
        if let image = networkController?.fetchImage(for: celebrity) {
            imageView.image = image
        }
    }
    
    // MARK: - Actions
    
    @IBAction func answerTapped(_ sender: UIButton) {
        countdown.reset()
        guard let celebrity = celebrity else { return }
        let answer: AnswerType = sender == deadButton ? .dead : .alive
        
        displayResult(for: gameController.checkAnswer(answer, for: celebrity))
    }
    
    // MARK: - Private
    
    private func setTotalQuestions() {
        totalQuestions = gameController.testCelebrities.count
    }
    
    private func displayResult(for correct: Bool) {
       
        deadButton.isEnabled = false
        aliveButton.isEnabled = false
        continueButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        continueButton.widthAnchor.constraint(equalToConstant: 100).isActive  = true
        continueButton.centerXAnchor.constraint(equalTo: correctFilterView.centerXAnchor).isActive = true
        continueButton.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        continueButton.layer.cornerRadius = 4
        continueButton.isHidden = false
        switch correct {
        case true:
            correctFilterView.layer.backgroundColor = UIColor(displayP3Red: 58.0/255, green: 143.0/255, blue: 18.0/255, alpha: 0.4).cgColor
            correctFilterView.isHidden = false
        case false:
            // red overlay with "ok" button
            correctFilterView.layer.backgroundColor = UIColor(displayP3Red: 234.0/255, green: 95.0/255, blue: 95.0/255, alpha: 0.4).cgColor
            correctFilterView.isHidden = false
        }
    }
    
    func updateTimeView() {
        
        
        switch countdown.state {
        case .started:
            timeLabel.text = string(from: countdown.timeRemaining)
        case .finished:
            timeLabel.text = string(from: 0)
        case .reset:
            timeLabel.text = string(from: countdown.duration)
        }
    }

    @IBAction func continueQuiz(_ sender: Any) {
        if gameController.gameStatus == .active {
            celebrity = gameController.getRandomCelebrity()
            deadButton.isEnabled = true
            aliveButton.isEnabled = true
            updateViews()
        } else {
            gameController.getScore(for: gameController.gameLevel
            )
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

extension QuestionViewController: CountdownDelegate {
    func countdownDidUpdate(timeRemaining: TimeInterval) {
        updateTimeView()
    }
    
    func countdownDidFinish() {
        updateTimeView()
        
        guard let celebrity = celebrity else { return }
        
        switch celebrity.isAlive {
        case true: displayResult(for: gameController.checkAnswer(.dead, for: celebrity))
        case false: displayResult(for: gameController.checkAnswer(.alive, for: celebrity))
        }
        
        
    }
}
