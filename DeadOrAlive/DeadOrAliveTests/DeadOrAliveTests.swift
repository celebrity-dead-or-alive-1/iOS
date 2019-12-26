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
        
        XCTAssertEqual(gameController.celebrities.count, 3)
        
        let _ = gameController.getRandomCelebrity()
        
        XCTAssertEqual(gameController.celebrities.count, 2)
    }
    
    

//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
