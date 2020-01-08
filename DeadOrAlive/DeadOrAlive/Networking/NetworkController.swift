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
            print(error, data)
            guard let data = data else {
                completion(NSError())
                return
            }
            
            do {
                let currentUser = try JSONDecoder().decode(UserRepresentation.self, from: data)
                
                let context = CoreDataStack.shared.container.newBackgroundContext()
                
                self.user = User(userRepresentation: currentUser, context: context)
                
                try CoreDataStack.shared.save(context: context)
                
                guard let token = currentUser.token/*,
                    let id = currentUser.id*/ else { throw NSError() }
                self.user?.token = token
                print(token)
//                self.user?.id = id
            } catch {
                print("Error decoding user object: \(error)")
                completion(error)
                return
            }
            // TODO - save user to CoreData!!!
            completion(nil)
        }.resume()
    }
    
    func fetchHighScores() {
        
    }
    
    func sendHighScore() {
        
    }
    
    func fetchAllCelebrities(completion: @escaping (Result<[CelebrityRepresentation],Error>) -> ()) {
        let celebritiesURL = baseUrl.appendingPathComponent("/celeb/")
        
        
        var request = URLRequest(url: celebritiesURL.usingHTTPS!)
        request.httpMethod = HTTPMethod.get
        request.setValue("application.json", forHTTPHeaderField: "Content-Type")
//        request.setValue(user?.token, forHTTPHeaderField: "Authorization")
        

        
        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                print("Error receiving Celebrities data: \(error)")
            }
            
            print(String(data: data!, encoding: .utf8))
            guard let data = data else {
                completion(.failure(NSError()))
                return
            }

            

            do {
                let decoded = try JSONDecoder().decode([CelebrityRepresentation].self, from: data)
//                self.updateCelebrities(with: decoded)
                
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
                    print(celebrity.imageURL)
                    print("\(celebrity.localImageFile)")
                    print("Updating: \(celebrity.name)")
                    celebrity.id = Int16(representation.id)
                    celebrity.name = representation.name
                    celebrity.imageURL = representation.imageURL
                    celebrity.localImageFile = representation.localImageFile
                    celebrity.factoid = representation.factoid
                    celebrity.birthYear = Int16(representation.birthYear)
                    celebrity.isAlive = Int16(representation.isAlive)
                    
                    celebritiesToCreate.removeValue(forKey: id)
                    
                    if celebrity.localImageFile == nil {
                        self.fetchRemoteImageData(for: celebrity)
                    }
                }
                
                for representation in celebritiesToCreate.values {
                    print("Creating \(representation.name)")
                    let celebrity = Celebrity(celebrityRepresentation: representation, context: context)
//                    try CoreDataStack.shared.save(context: context)
//                    fetchRemoteImageData(for: celebrity)
                }
                try CoreDataStack.shared.save(context: context)
            } catch {
                NSLog("Error fetching celebrities from persistent store: \(error)")
            }
        }
    }
    
    func addCelebrity() {

    } // I may not include this
    
    func fetchRemoteImageData(for celebrity: Celebrity) {
        guard let imageURL = celebrity.imageURL else { return }
        
        var request = URLRequest(url: imageURL)
        request.httpMethod = HTTPMethod.get
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            
            if let error = error {
                print("Error fetching \(celebrity.name ?? "a celebrity")'s image: \(error)")
            }
            guard let safeData = data,
                let imageFolderString = self.localImageFolder?.absoluteString else { return }
//            print(String(data: safeData, encoding: .utf8))
//            print(safeData)
            let image = UIImage(data: safeData)
//            let nsData = NSData(base64Encoded: safeData, options: .ignoreUnknownCharacters)// safeData as NSData
                
            // Figure out file type (jpg, png, etc)
            // move absoluteString to guard let
            guard let url = self.localImageFolder?.appendingPathComponent("local\(celebrity.id).jpg") else { print("yuk")
                return }
            
            do {
                try safeData.write(to: url)
            } catch {
                print(error)
            }
            
            celebrity.localImageFile = url.absoluteString
            try? CoreDataStack.shared.mainContext.save()
//            print(celebrity.localImageFile)
//            let readData = try? Data(contentsOf: url)
//            if let safeReadData = readData {
//                let image = UIImage(data: safeReadData)
////                print("Image: \(image)")
//                
//            } else { print("nope")}
            
            //                let successfulWrite = nsData.write(to: url, atomically: true)
            //                print(successfulWrite)
            
            
            
            
            // returns a boolean for success, if it fails, Log the failure
            
//            Add property to Celebrity for holding the completed url: \(self.localImageFolder?.absoluteString)/\(celebrity.id).jpg
                
//                let localImageURL = self.localImageURL else { return }
//            self.celebrityPhotosData[celebrity.id] = data
            
            
            
            
            // Don't need below if nsData.write() works
            
//            do {
//                let encoded = try PropertyListEncoder().encode(self.celebrityPhotosData)
//                try encoded.write(to: localImageURL)
//            } catch {
//                print("Error saving image data: \(error)")
//            }
        }.resume()
    }
    
    func fetchImage(for celebrity: Celebrity) -> UIImage {
        if celebrity.localImageFile == nil {
            DispatchQueue.main.sync {
                fetchImage(for: celebrity)
            }
        }
        
        guard let imageFile = celebrity.localImageFile,
            let url = URL(string: imageFile),
            let data = try? Data(contentsOf: url),
            let image = UIImage(data: data) else { return UIImage() }
        
        return image // TODO: get the data from the URL, then return the image here
    }
}
