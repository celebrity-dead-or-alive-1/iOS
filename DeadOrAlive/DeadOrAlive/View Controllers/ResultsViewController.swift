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
    
    // MARK: - Properties
    
    var gameController: GameController?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    
    
    func saveScore() {
        
    }
    
    // MARK: - Actions
    
    @IBAction func startNewGame(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func updateViews() {
        guard let correct = gameController?.numberRight,
            let total = gameController?.totalAnswered else { return }
        resultLabel.text = "\(correct) correct out of \(total)"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == PropertyKeys.signUpSegue {
            guard let signUpVC = segue.destination as? SignUpViewController else { return }
            signUpVC.hasResults = true
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
