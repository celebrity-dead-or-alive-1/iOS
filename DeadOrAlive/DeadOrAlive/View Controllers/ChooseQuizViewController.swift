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
    
    // MARK: - Properties
    
    let networkController = NetworkController()
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
//        networkController.user = User(username: "randomUser2", password: "thePassword", email: "randomUser2@gmail.com", id: 5, token: nil, isAdmin: false)
//        guard let user = networkController.user else { return }
//        networkController.loginUser(user) { error in
//            if let error = error {
//                print(error)
//            }
//            self.networkController.fetchAllCelebrities()
//        }
        
        networkController.fetchAllCelebrities()
        
        
//        networkController.registerUser(with: "randomUser2", password: "thePassword", email: "randomUser2@gmail.com") { error in
//            if let error = error {
//                print(error)
//            }
//        }
    }

    // MARK: - Actions
    
    // MARK: - Private
    
    private func updateViews() {
        let styledButtons = [easyButton, mediumButton, hardButton, customButton, highScoresButton]
        
        for button in styledButtons {
            button?.layer.cornerRadius = 4
            button?.layer.cornerCurve = .continuous
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case PropertyKeys.loginSegue, PropertyKeys.signUpSegue:
            let loginVC = segue.destination //as? LOGINVIEWCONTROLLER
        default:
            // Test segue setup here
            break
        }
    }
}

