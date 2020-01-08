//
//  User+Convenience.swift
//  DeadOrAlive
//
//  Created by morse on 1/6/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation
import CoreData

extension User {
    
    var userRepresentation: UserRepresentation? {
        
        guard let username = username,
            let password = password,
            let email = email else { return nil }
        
        return UserRepresentation(username: username, password: password, email: email, id: Int(id), token: token, isAdmin: isAdmin)
    }
    
    @discardableResult convenience init(username: String,
                                        password: String,
                                        email: String,
                                        id: Int,
                                        token: String,
                                        isAdmin: Bool = false,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.username = username
        self.password = password
        self.email = email
        self.id = Int16(id)
        self.token = token
        self.isAdmin = isAdmin
    }
    
    @discardableResult convenience init(userRepresentation: UserRepresentation, context: NSManagedObjectContext) {
        
        self.init(username: userRepresentation.username,
                  password: userRepresentation.password ?? "",
                  email: userRepresentation.email ?? "",
                  id: userRepresentation.id,
                  token: userRepresentation.token ?? "",
                  isAdmin: userRepresentation.isAdmin ?? false)
    }
    
}
