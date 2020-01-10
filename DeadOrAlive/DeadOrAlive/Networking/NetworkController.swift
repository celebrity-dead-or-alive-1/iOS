//
//  NetworkController.swift
//  DeadOrAlive
//
//  Created by morse on 12/26/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation
import UIKit
import CoreData
//import ImageIO

class NetworkController {
    
    // MARK: - Properties
    
    let baseUrl = URL(string: "https://ogr-ft-celebdoa.herokuapp.com/api")!
    var localImageFolder: URL? {
        let fileManager = FileManager.default
        let directory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first
        return directory//?.appendingPathComponent(PropertyKeys.imagePathComponent)
    }
    var celebrityPhotosData: [Int: Data] = [:]
    var user: User? // This should end up living in CoreData
    var celebrities: [Celebrity] = [] // This should end up living in CoreData
    
    // MARK: - Networking Methods
    
    func registerUser(with username: String, password: String, email: String, completion: @escaping (Error?) -> ()) {
        let loginUrl = baseUrl.appendingPathComponent("auth/register/")
        
        let json = """
        {
        "username": "\(username)",
        "password": "\(password)",
        "email": "\(email)"
        }
        """
        
        let jsonData = json.data(using: .utf8)
        guard let unwrapped = jsonData else {
            print("No data!")
            return
        }
        
        var request = URLRequest(url: loginUrl)
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = unwrapped
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                var userRepresentation = try JSONDecoder().decode(UserRepresentation.self, from: data)
                userRepresentation.email = email
                userRepresentation.password = password
                userRepresentation.isAdmin = false
                self.user = User(userRepresentation: userRepresentation, context: CoreDataStack.shared.mainContext)
                try? CoreDataStack.shared.mainContext.save()
            } catch {
                print("Error decoding user object: \(error)")
                completion(error)
                return
            }
            completion(nil)
        }.resume()
    }
    
    func loginUser(_ username: String, password: String, completion: @escaping (Error?) -> ()) {
        let loginUrl = baseUrl.appendingPathComponent("auth/login/")
        var request = URLRequest(url: loginUrl)
        
        let json = """
        {
        "username": "\(username)",
        "password": "\(password)"
        }
        """
        
        let jsonData = json.data(using: .utf8)
        guard let unwrapped = jsonData else {
            print("No data!")
            return
        }
        
        request.httpBody = unwrapped
        
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        print(request)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            
            if let error = error {
                completion(error)
                return
            }

            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                let currentUser = try JSONDecoder().decode(UserRepresentation.self, from: data)
                
                let context = CoreDataStack.shared.mainContext
                
                self.user = User(userRepresentation: currentUser, context: context)
                
                try CoreDataStack.shared.save(context: context)
                
                guard let token = currentUser.token else { throw NSError() }
                self.user?.token = token

            } catch {
                print("Error decoding user object: \(error)")
                completion(error)
                return
            }
            completion(nil)
            return
        }.resume()
    }
    
    func fetchUserHighScores(user: User) {
        let scoreURL = baseUrl.appendingPathComponent("users/scores/\(Int(user.id))")
        guard let token = user.token else { return }
        var request = URLRequest(url: scoreURL)
        
        request.httpMethod = HTTPMethod.get
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
//                completion(error)
                return
            }
            
            guard let data = data else {
//                completion(NSError())
                return
            }
            
            let moc = CoreDataStack.shared.mainContext

            do {
                let scores = try JSONDecoder().decode([ScoreRepresentation].self, from: data)
                _ = scores.compactMap {
                    Score(scoreRepresentation: $0, context: moc)
                }
            } catch {
                print("Error decoding [Score] objects: \(error)")
            }
            
            do {
                try moc.save()
            } catch {
                print("Error saving Scores: \(error)")
            }
        }
    }
    
    func sendHighScore(for user: User, score: Int, time: Int, completion: @escaping (Error?) -> ()) {
        
        let scoreURL = baseUrl.appendingPathComponent("users/score")
        var request = URLRequest(url: scoreURL)
        print(score, user.id, time)
        let json = """
        {
        "score": \(score),
        "user_id": \(Int(user.id)),
        "time": \(time)
        }
        """
        let possibleJSONData = json.data(using: .utf8)
        guard let jsonData = possibleJSONData else {
            print("No data!")
            return
        }
        guard let token = user.token else {
            print("No token!")
            return
        }
        
        request.httpBody = jsonData
        request.httpMethod = HTTPMethod.post
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("\(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print(error)
                completion(error)
                return
            }
            
            guard let data = data else {
                completion(NSError())
                return
            }

            do {
                let scoreID = try JSONDecoder().decode(Int.self, from: data)
                
                Score(id: scoreID, score: score, userID: Int(user.id), time: time)
                
                try CoreDataStack.shared.mainContext.save()
            } catch {
                print("Error decoding Score object: \(error)")
                completion(error)
                return
            }

            completion(nil)
            return
        }.resume()
    }
    
    func fetchAllCelebrities(completion: @escaping (Result<[CelebrityRepresentation],Error>) -> ()) {
        let celebritiesURL = baseUrl.appendingPathComponent("/celeb/")
        
        var request = URLRequest(url: celebritiesURL.usingHTTPS!)
        request.httpMethod = HTTPMethod.get
        request.setValue("application.json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Error receiving Celebrities data: \(error)")
            }
            
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }
            do {
                let decoded = try JSONDecoder().decode([CelebrityRepresentation].self, from: data)
                completion(.success(decoded))
                return
            } catch {
                print("Error decoding [Celebrity] object: \(error)")
                completion(.failure(error))
                return
            }
        }.resume()
    }

    
    func updateCelebrities(with representations: [CelebrityRepresentation]) {
        
        let identifiersToFetch = representations.map { $0.id }
        
        let representationsByID = Dictionary(uniqueKeysWithValues: zip(identifiersToFetch, representations))
        
        var celebritiesToCreate = representationsByID
        
        let context = CoreDataStack.shared.mainContext//container.newBackgroundContext()
        
        context.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<Celebrity> = Celebrity.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "id in %@", identifiersToFetch)
                
                let existingCelebrities = try context.fetch(fetchRequest)
                
                for celebrity in existingCelebrities {
                    let id = Int(celebrity.id)
                    guard let representation = representationsByID[id] else { continue }

                    print("Updating: \(celebrity.name ?? "No one")")
                    celebrity.id = Int16(representation.id)
                    celebrity.name = representation.name
                    celebrity.imageURL = representation.imageURL
                    celebrity.localImageFile = representation.localImageFile
                    celebrity.factoid = representation.factoid
                    celebrity.birthYear = Int16(representation.birthYear)
                    celebrity.isAlive = representation.isAlive// Int16(representation.isAlive)
                    
                    celebritiesToCreate.removeValue(forKey: id)
                    
                    if celebrity.localImageFile == nil {
                        self.fetchRemoteImageData(for: celebrity)
                    }
                }
                
                for representation in celebritiesToCreate.values {
                    print("Creating \(representation.name)")
                    Celebrity(celebrityRepresentation: representation, context: context)
                }
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error fetching celebrities from persistent store: \(error)")
            }
        }
    }
    
    func fetchRemoteImageData(for celebrity: Celebrity) {
        guard let imageURL = celebrity.imageURL?.usingHTTPS else { return }
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print("Error fetching \(celebrity.name ?? "a celebrity")'s image: \(error)")
            }
            guard let safeData = data/*,
                let imageFolderString = self.localImageFolder?.absoluteString*/ else { return }

//            let image = UIImage(data: safeData)

            guard let url = self.localImageFolder?.appendingPathComponent("local\(celebrity.id).jpg") else { print("yuk")
                return }
            
            do {
                try safeData.write(to: url)
            } catch {
                print(error)
            }
            
            celebrity.localImageFile = url.absoluteString
            try? CoreDataStack.shared.mainContext.save()
        }.resume()
    }
    
    func fetchImage(for celebrity: Celebrity) -> UIImage {
        if celebrity.localImageFile == nil {
            print("\(celebrity.name!)'s picture doesn't exist")
//            DispatchQueue.main.sync {
//                fetchRemoteImageData(for: celebrity)
//            }
        }
        guard let url = self.localImageFolder?.appendingPathComponent("local\(celebrity.id).jpg"),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else {
                print("no local image")
                return UIImage() }
        
        return image
    }
}
