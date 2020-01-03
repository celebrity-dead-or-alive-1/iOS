//
//  PropertyKeys.swift
//  DeadOrAlive
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

struct PropertyKeys {
    static let easySegue = "ShowEasyTestSegue"
    static let mediumSegue = "ShowMediumTestSegue"
    static let hardSegue = "ShowHardTestSegue"
    static let customSegue = "ShowCustomTestSegue"
    static let highScoreSegue = "ShowHighScoreSegue"
    static let loginSegue = "ShowLoginSegue"
    static let signUpSegue = "ShowSignUpSegue"
    static let restultsSegue = "ShowResultsSegue"
    
    static let imagePathComponent = "celebrityImage.plist"
}

enum AnswerType {
    case alive, dead
}

enum GameLevel: String {
    case easy = "Easy", medium = "Medium" , hard = "Hard" //, custom = "Custom"
}
