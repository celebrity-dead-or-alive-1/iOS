//
//  ViewController.swift
//  DeadOrAlive
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import UIKit

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
    var user: User?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        let userDefaults = UserDefaults.standard
        userDefaults.set(false, forKey: PropertyKeys.downloadedKey)
        updateViews()
//        networkController.user = User(username: "randomUser2", password: "thePassword", email: "randomUser2@gmail.com", id: 5, token: nil, isAdmin: false)
//        guard let user = networkController.user else { return }
//        networkController.loginUser(user) { error in
//            if let error = error {
//                print(error)
//            }
//            self.networkController.fetchAllCelebrities()
//        }
        
//        networkController.fetchAllCelebrities()
        
        
//        networkController.registerUser(with: "randomUser2", password: "thePassword", email: "randomUser2@gmail.com") { error in
//            if let error = error {
//                print(error)
//            }
//        }
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
    
//    @IBAction func unwindToLevelViewController() {
//
//    }
    
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
            signUpButton.isHidden = true
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

