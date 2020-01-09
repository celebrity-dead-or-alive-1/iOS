//
//  CelebrityRepresentation.swift
//  DeadOrAlive
//
//  Created by morse on 1/6/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

struct CelebrityRepresentation: Codable, Equatable {
    let id: Int
    let name: String
    let imageURL: URL
    let localImageFile: String?
    let factoid: String
    let birthYear: Int
    let isAlive: Bool
    
    enum CodingKeys: String, CodingKey {
        
        case id, name = "celebname", imageURL = "image_url", localImageFile, factoid, birthYear = "birthyear", isAlive = "alive"
    }
    
//    func decode {
//
//    }
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
