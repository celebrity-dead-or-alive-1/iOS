//
//  CelebrityController.swift
//  DeadOrAlive
//
//  Created by morse on 12/25/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

class CelebrityController {
    var celebrities: [Celebrity] = [
        Celebrity(id: 01, name: "Jed", imageURL: URL(string: "google.com")!, factoid: "happy", birthYear: 1942, alive: true),
        Celebrity(id: 02, name: "Ned", imageURL: URL(string: "github.com")!, factoid: "sad", birthYear: 1940, alive: false),
        Celebrity(id: 11, name: "Ted", imageURL: URL(string: "aol.com")!, factoid: "angry", birthYear: 1946, alive: true)]
    
    
}

struct Celebrity {
    let id: Int
    let name: String
    let imageURL: URL
    let factoid: String
    let birthYear: Int
    let alive: Bool
    
    enum CelebrityCodingKeys: String, CodingKey {
        
        case id, name = "celebname", imageURL = "image_url", factoid, birthYear = "birthyear", alive
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
