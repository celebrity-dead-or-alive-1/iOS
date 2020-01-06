//
//  ScoreRepresentation.swift
//  DeadOrAlive
//
//  Created by morse on 1/6/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

struct ScoreRepresentation: Codable, Equatable {
    let id: Int
    let score: Int
    let userID: Int
    let time: Int
    
    enum ScoreCodingKeys: String, CodingKey {
        case id, score, userID = "user_id", time
    }
}
