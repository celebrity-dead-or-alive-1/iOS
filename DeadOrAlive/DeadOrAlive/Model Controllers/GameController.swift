//
//  CelebrityController.swift
//  DeadOrAlive
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import CoreData

class GameController {
    
    // MARK: - Properties
    
    var gameStatus: GameStatus = .active
    var gameLevel: GameLevel = .easy
    var numberRight: Int = 0
    var numberWrong: Int = 0
    var totalAnswered: Int {
        return numberRight + numberWrong
    }
    var allCelebrities:[Celebrity] {
        let fetchRequest: NSFetchRequest<Celebrity> = Celebrity.fetchRequest()
        let moc = CoreDataStack.shared.mainContext
        do {
            let celebrities = try moc.fetch(fetchRequest)
            return celebrities
        } catch {
            NSLog("Error fetching celebrities: \(error)")
            return []
        }
    }
    /// This is the list of celebrities that will be tested during this game, not the full list.
    var testCelebrities: [Celebrity] = []
        
//        = [
//        Celebrity(id: 01, name: "Jed", imageURL: URL(string: "google.com")!, factoid: "happy", birthYear: 1942, isAlive: 0),
//        Celebrity(id: 02, name: "Ned", imageURL: URL(string: "github.com")!, factoid: "sad", birthYear: 1940, isAlive: 1),
//        Celebrity(id: 11, name: "Ted", imageURL: URL(string: "aol.com")!, factoid: "angry", birthYear: 1946, isAlive: 0)]
    var celebrityPhotosData: [Int: Data] = [:]
    var localImageURL: URL? {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory?.appendingPathComponent(PropertyKeys.imagePathComponent)
    }
    
    enum GameStatus: Equatable {
        case active, finished
    }
    
    init() {
        getTestCelebrities()
    }
    
    func getRandomCelebrity() -> Celebrity {
        
        if testCelebrities.isEmpty {
            getTestCelebrities()
        }
        
        let index = Int.random(in: 0..<testCelebrities.count)
        
        return testCelebrities.remove(at: index)
    }
    
    func getTestCelebrities() {
        var celebrity: Celebrity
        for _ in 1...2 {
            repeat {
                let tempCelebrity = allCelebrities.randomElement()
                guard let safeCelebrity = tempCelebrity else { return }
                celebrity = safeCelebrity
            
            } while testCelebrities.contains(celebrity)
            testCelebrities.append(celebrity)
        }
    }
    
    func checkAnswer(_ answer: AnswerType, for celebrity: Celebrity) -> Bool {
        let answerBool = answer == .alive ? 1 : 0
        switch celebrity.isAlive == answerBool  {
        case true:
            numberRight += 1
            updateStatus()
            return true
        case false:
            numberWrong += 1
            updateStatus()
            return false
        }
    }
    
    func updateStatus() {
        switch testCelebrities.count == 0 {
        case true: gameStatus = .finished
        case false: return
        }
    }
    
    func fetchTestCelebrityPhotos() {
        do {
            let fileManager = FileManager.default
            guard let url = localImageURL,
                fileManager.fileExists(atPath: url.path) else { return }
            do {
                let data = try Data(contentsOf: url)
                celebrityPhotosData = try PropertyListDecoder().decode([Int: Data].self, from: data)
            } catch {
                NSLog("Could not retrieve celebrity photos: \(error)")
            }
        }
    }
}








