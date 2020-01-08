//
//  Score+Convenience.swift
//  DeadOrAlive
//
//  Created by morse on 1/6/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation
import CoreData

extension Score {
    
    var scoreRepresentation: ScoreRepresentation? {
        
        return ScoreRepresentation(id: Int(id), score: Int(score), userID: Int(userID), time: Int(time))
    }
    
    @discardableResult convenience init(id: Int, score: Int, userID: Int, time: Int, context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = Int16(id)
        self.score = Int16(score)
        self.userID = Int16(userID)
        self.time = Int16(time)
    }
    
    @discardableResult convenience init(scoreRepresentation: ScoreRepresentation, context: NSManagedObjectContext) {
        self.init(id: scoreRepresentation.id,
                  score: scoreRepresentation.score,
                  userID: scoreRepresentation.userID,
                  time: scoreRepresentation.time)
    }
}
