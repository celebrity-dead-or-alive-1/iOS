//
//  CelebrityController.swift
//  DeadOrAlive
//
//  Created by morse on 12/26/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

class CelebrityController {
    var allCelebrities: [Celebrity] = []
    
    func getTestCelebrities(quantity: Int) {
        var count = 0
        var tempCelebrities = allCelebrities
        var gameCelebrities: [Celebrity] = []
        
        repeat {
            let index = Int.random(in: 0..<tempCelebrities.count)
            
            gameCelebrities.append(tempCelebrities.remove(at: index))
            count += 1
        } while count != quantity
    }
}
