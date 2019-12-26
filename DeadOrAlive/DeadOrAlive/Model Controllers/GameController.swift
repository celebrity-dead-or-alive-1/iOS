//
//  CelebrityController.swift
//  DeadOrAlive
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

class GameController {
    
    // MARK: - Properties
    
    var gameStatus: GameStatus = .active
    var numberRight: Int = 0
    var numberWrong: Int = 0
    var totalAnswered: Int {
        return numberRight + numberWrong
    }
    /// This is the list of celebrities that will be tested during this game, not the full list.
    var testCelebrities: [Celebrity] = [
        Celebrity(id: 01, name: "Jed", imageURL: URL(string: "google.com")!, factoid: "happy", birthYear: 1942, isAlive: true),
        Celebrity(id: 02, name: "Ned", imageURL: URL(string: "github.com")!, factoid: "sad", birthYear: 1940, isAlive: false),
        Celebrity(id: 11, name: "Ted", imageURL: URL(string: "aol.com")!, factoid: "angry", birthYear: 1946, isAlive: true)]
    
    enum GameStatus: Equatable {
        case active, finished
    }
    
    func getRandomCelebrity() -> Celebrity {
        let index = Int.random(in: 0..<testCelebrities.count)
        
        return testCelebrities.remove(at: index)
    }
    
    func checkAnswer(_ answer: AnswerType, for celebrity: Celebrity) {
        let answerBool = answer == .alive ? true : false
        switch celebrity.isAlive == answerBool  {
        case true:
            numberRight += 1
        case false:
            numberWrong += 1
        }
        updateStatus()
    }
    
    func updateStatus() {
        switch totalAnswered == testCelebrities.count {
        case true: gameStatus = .finished
        case false: return
        }
    }
    
    
}

struct Celebrity: Codable, Equatable {
    let id: Int
    let name: String
    let imageURL: URL
    let factoid: String
    let birthYear: Int
    let isAlive: Bool
    
    enum CelebrityCodingKeys: String, CodingKey {
        
        case id, name = "celebname", imageURL = "image_url", factoid, birthYear = "birthyear", isAlive = "alive"
    }
}

struct User: Codable, Equatable {
    let username: String
    let password: String
    let email: String
    let id: String
    let token: String
    let isAdmin: Bool
    
    enum UserCodingKeys: String, CodingKey {
        case username, password, email, id, token, isAdmin = "admin"
    }
}
/*
"""
{
"id": 5,
"celebname": "Freddy Heineken",
"image_url": "https://specials-images.forbesimg.com/imageserve/5d8e22cc6de3150009a54b53/960x0.jpg",
"factoid": "Dutch beer brewer (Heineken).",
"birthyear": 1923,
"alive": 0
}
"""
*/
