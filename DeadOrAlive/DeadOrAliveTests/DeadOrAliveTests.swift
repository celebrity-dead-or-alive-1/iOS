//
//  DeadOrAliveTests.swift
//  DeadOrAliveTests
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import XCTest
@testable import DeadOrAlive

class DeadOrAliveTests: XCTestCase {

    func testGettingCelebrity() {
        let gameController = GameController()
        
        XCTAssertEqual(gameController.testCelebrities.count, 3)
        
        let _ = gameController.getRandomCelebrity()
        
        XCTAssertEqual(gameController.testCelebrities.count, 2)
    }
    
    func testCorrectTrueAnswer() {
        let gameController = GameController()
        let celebrity = gameController.testCelebrities[0]
        
        XCTAssertEqual(gameController.numberRight, 0)
        XCTAssertEqual(gameController.numberWrong, 0)
        XCTAssertEqual(gameController.totalAnswered, 0)
        
        gameController.checkAnswer(.alive, for: celebrity)
        
        XCTAssertEqual(gameController.numberRight, 1)
        XCTAssertEqual(gameController.numberWrong, 0)
        XCTAssertEqual(gameController.totalAnswered, 1)
    }
    
    func testCorrectFalseAnswer() {
        let gameController = GameController()
        let celebrity = gameController.testCelebrities[1]
        
        XCTAssertEqual(gameController.numberRight, 0)
        XCTAssertEqual(gameController.numberWrong, 0)
        XCTAssertEqual(gameController.totalAnswered, 0)
        
        gameController.checkAnswer(.dead, for: celebrity)
        
        XCTAssertEqual(gameController.numberRight, 1)
        XCTAssertEqual(gameController.numberWrong, 0)
        XCTAssertEqual(gameController.totalAnswered, 1)
    }
    
    func testWrongTrueAnswer() {
        let gameController = GameController()
        let celebrity = gameController.testCelebrities[1]
        
        XCTAssertEqual(gameController.numberRight, 0)
        XCTAssertEqual(gameController.numberWrong, 0)
        XCTAssertEqual(gameController.totalAnswered, 0)
        
        gameController.checkAnswer(.alive, for: celebrity)
        
        XCTAssertEqual(gameController.numberRight, 0)
        XCTAssertEqual(gameController.numberWrong, 1)
        XCTAssertEqual(gameController.totalAnswered, 1)
    }
    
    func testWrongFalseAnswer() {
        let gameController = GameController()
        let celebrity = gameController.testCelebrities[0]
        
        XCTAssertEqual(gameController.numberRight, 0)
        XCTAssertEqual(gameController.numberWrong, 0)
        XCTAssertEqual(gameController.totalAnswered, 0)
        
        gameController.checkAnswer(.dead, for: celebrity)
        
        XCTAssertEqual(gameController.numberRight, 0)
        XCTAssertEqual(gameController.numberWrong, 1)
        XCTAssertEqual(gameController.totalAnswered, 1)
    }
    
    func testGameStatusRemainsActive() {
        let gameController = GameController()
        let celebrity0 = gameController.testCelebrities[0]
        let celebrity1 = gameController.testCelebrities[1]
        
        XCTAssertEqual(gameController.gameStatus, .active)
        
        gameController.checkAnswer(.alive, for: celebrity0)
        gameController.checkAnswer(.alive, for: celebrity1)
        
        XCTAssertEqual(gameController.gameStatus, .active)
    }
    
    func testGameStatusChangesToFinished() {
        let gameController = GameController()
        let celebrity0 = gameController.testCelebrities[0]
        let celebrity1 = gameController.testCelebrities[1]
        let celebrity2 = gameController.testCelebrities[2]
        
        XCTAssertEqual(gameController.gameStatus, .active)
        
        gameController.checkAnswer(.alive, for: celebrity0)
        gameController.checkAnswer(.alive, for: celebrity1)
        gameController.checkAnswer(.alive, for: celebrity2)
        
        XCTAssertEqual(gameController.gameStatus, .finished)
    }

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
