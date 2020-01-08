//
//  LoginViewController.swift
//  DeadOrAlive
//
//  Created by morse on 1/3/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var returnButton: UIButton!
    
    // MARK: - Properties
    
    var networkController: NetworkController?
    
    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        updateViews()
    }
    
    // MARK: - Actions
    
    @IBAction func forgotButtonTapped(_ sender: Any) {
    }
    
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let username = usernameTextField.text,
            let password = passwordTextField.text,
            !username.isEmpty,
            !password.isEmpty else { return }
        
        networkController?.loginUser(username, password: password, completion: { error in
            if let error = error {
                print("Error logging in \(username) with password (\(password)): \(error)")
            } else {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        })
        // Login functionality goes here
        
    }
    
    @IBAction func returnButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Views
    
    func updateViews() {
        loginButton.layer.cornerRadius = 4
        loginButton.layer.borderColor = UIColor.black.cgColor
        loginButton.layer.borderWidth = 1.5
        
        returnButton.layer.cornerRadius = 4
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
