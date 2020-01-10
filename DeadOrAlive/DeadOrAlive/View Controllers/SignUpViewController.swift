//
//  SignUpViewController.swift
//  DeadOrAlive
//
//  Created by morse on 1/4/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var homepageButton: UIButton!
    
    // MARK: - Properties
    
    var networkController: NetworkController?
    var hasResults: Bool = false
    var score: Int?
    var time: Double?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        updateViews()
    }
    
    func updateViews() {
        if hasResults {
            print("Hide")
            homepageButton.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func createAcountTapped(_ sender: Any) {
        
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            let passwordCheck = confirmPasswordTextField.text,
            let email = emailTextField.text,
            !username.isEmpty,
            !password.isEmpty,
            !email.isEmpty else { return } // TODO: If this fails, it should show an alert, not just return.
        
        if password != passwordCheck && !password.isEmpty {
            return // This should show an alert, not just return.
        } else {
            networkController?.registerUser(with: username, password: password, email: email, completion: { error in
                if let error = error {
                    DispatchQueue.main.async {
                        print("Error registering user: \(error)") // This should be an alert as well.
                    }
                } else {
                    self.networkController?.loginUser(username, password: password, completion: { error in
                        if let error = error {
                            print("Error logging user in: \(error)")
                        } else {
                            self.sendScore()
                            DispatchQueue.main.async {
                                self.dismiss(animated: true, completion: nil)
                            }
                        }
                    })
                }
            })
        }
    }
    
    func sendScore() {
        guard let score = score,
            let time = time,
            let user = networkController?.user else { return }
        networkController?.sendHighScore(for: user, score: score, time: Int(time), completion: { error in
            if let error = error {
                print("Error sending score: \(error)")
            }
        })
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createAcountTapped(textField)
        return true
    }
}
