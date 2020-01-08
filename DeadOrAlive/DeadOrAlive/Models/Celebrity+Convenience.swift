//
//  Celebrity+Convenience.swift
//  DeadOrAlive
//
//  Created by morse on 1/6/20.
//  Copyright © 2020 morse. All rights reserved.
//

import Foundation
import CoreData

extension Celebrity {
    
    var celbrityRepresentation: CelebrityRepresentation? {
        
        guard let name = name,
            let imageURL = imageURL,
            let factoid = factoid else { return nil }
        
        return CelebrityRepresentation(id: Int(id), name: name, imageURL: imageURL, localImageFile: localImageFile, factoid: factoid, birthYear: Int(birthYear), isAlive: Int(isAlive))
    }
    
    @discardableResult convenience init(id: Int,
                                        name: String,
                                        imageURL: URL,
                                        localImageFile: String,
                                        factoid: String,
                                        birthYear: Int,
                                        isAlive: Int,
                                        context: NSManagedObjectContext = CoreDataStack.shared.mainContext) {
        
        self.init(context: context)
        self.id = Int16(id)
        self.name = name
        self.imageURL = imageURL
        self.localImageFile = localImageFile
        self.factoid = factoid
        self.birthYear = Int16(birthYear)
        self.isAlive = Int16(isAlive)
    }
    
    @discardableResult convenience init(celebrityRepresentation: CelebrityRepresentation, context: NSManagedObjectContext) {
        
        self.init(id: celebrityRepresentation.id,
                  name: celebrityRepresentation.name,
                  imageURL: celebrityRepresentation.imageURL,
                  localImageFile: celebrityRepresentation.localImageFile ?? "",
                  factoid: celebrityRepresentation.factoid,
                  birthYear: celebrityRepresentation.birthYear,
                  isAlive: celebrityRepresentation.isAlive)
    }
}
