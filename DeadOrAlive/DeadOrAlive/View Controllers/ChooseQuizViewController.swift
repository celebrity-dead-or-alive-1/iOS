//
//  ViewController.swift
//  DeadOrAlive
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit
import CoreData

class ChooseQuizViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var customButton: UIButton!
    @IBOutlet weak var highScoresButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Properties
    
    let networkController = NetworkController()
//    let gameController = GameController()
    var user: User? {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        let possibleUsers = try? moc.fetch(fetchRequest)
        guard let users = possibleUsers,
            !users.isEmpty else { return nil }
        print(users[0].username)
        return users[0]
    }
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: PropertyKeys.downloadedKey)
        testScore()
        updateViews()
    }
    
    func testScore() {
        guard let user = user else { return }
        networkController.sendHighScore(for: user, score: 5, time: 1) { error in
            if let error = error {
                print("See error above.")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        
        updateViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userDefaults = UserDefaults.standard
        let celebritiesDownloaded = userDefaults.bool(forKey: PropertyKeys.downloadedKey)
        if !celebritiesDownloaded {
            performSegue(withIdentifier: PropertyKeys.downloadSegue, sender: self)
        }
    }

    // MARK: - Actions
    
    @IBAction func signUpButton(_ sender: Any) {
        if let _ = user {
            // Log out user
            let moc = CoreDataStack.shared.mainContext
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            let possibleUsers = try? moc.fetch(fetchRequest)
            guard let users = possibleUsers else { return }
            for user in users {
                moc.delete(user)
                try? CoreDataStack.shared.save(context: moc)
                signUpButton.setTitle("Dig your own grave & sign up here.", for: .normal)
                loginButton.setTitle("Log in", for: .normal)
            }
            
            let scoreFetchRequest: NSFetchRequest<Score> = Score.fetchRequest()
            let possibleScores = try? moc.fetch(scoreFetchRequest)
            guard let scores = possibleScores else { return }
            
            for score in scores {
                print("Deleting score")
                moc.delete(score)
            }
            try? CoreDataStack.shared.save(context: moc)
        } else {
            performSegue(withIdentifier: PropertyKeys.signUpSegue, sender: self)
        }
    }
    
    // MARK: - Private
    
    private func updateViews() {
        let styledButtons = [easyButton, mediumButton, hardButton, customButton, highScoresButton]
        
        for button in styledButtons {
            button?.layer.cornerRadius = 4
            button?.layer.cornerCurve = .continuous
        }
        if let user = user {
            guard let username = user.username else { return }
            loginButton.setTitle("\(username)", for: .normal)
            signUpButton.setTitle("Log Out", for: .normal)
//            signUpButton.isHidden = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case PropertyKeys.loginSegue:
            guard let loginVC = segue.destination as? LoginViewController else { return }
            loginVC.networkController = networkController
        case PropertyKeys.easySegue, PropertyKeys.mediumSegue, PropertyKeys.hardSegue, PropertyKeys.customSegue:
            guard let questionVC = segue.destination as? QuestionViewController else { return }
            questionVC.networkController = networkController
        case PropertyKeys.signUpSegue:
            guard let signUpVC = segue.destination as? SignUpViewController else { return }
            signUpVC.networkController = networkController
        case PropertyKeys.highScoreSegue:
            break
        default: return
        }
    }
    
//    private func levelFor(segue: UIStoryboardSegue) -> String {
//        switch segue.identifier {
//        case PropertyKeys.easySegue:
//            return GameLevel.easy.rawValue
//        case PropertyKeys.mediumSegue:
//            return GameLevel.medium.rawValue
//        case PropertyKeys.hardSegue:
//            return GameLevel.hard.rawValue
//        default:
//            return "None" // Custom!!!
//        }
//    }
}

