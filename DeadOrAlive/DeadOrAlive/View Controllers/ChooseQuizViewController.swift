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
    
    
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
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
}

