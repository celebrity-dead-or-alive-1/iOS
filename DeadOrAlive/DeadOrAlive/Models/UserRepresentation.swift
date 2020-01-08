//
//  UserRepresentation.swift
//  DeadOrAlive
//
//  Created by morse on 1/6/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable, Equatable {
    let username: String
    var password: String?
    var email: String?
    var id: Int
    var token: String?
    var isAdmin: Bool?
    
    enum UserCodingKeys: String, CodingKey {
        case username, password, email, id, token, isAdmin = "admin"
    }
}
