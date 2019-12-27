//
//  NetworkController.swift
//  DeadOrAlive
//
//  Created by morse on 12/26/19.
//  Copyright © 2019 morse. All rights reserved.
//

import Foundation

class NetworkController {
    
    // MARK: - Properties
    
    let baseUrl = URL(string: "https://ogr-ft-celebdoa.herokuapp.com/api")!
    var user: User? // This should end up living in CoreData
    
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
                self.user = try JSONDecoder().decode(User.self, from: data)
                self.user?.email = email
                self.user?.password = password
                self.user?.isAdmin = false
            } catch {
                print("Error decoding user object: \(error)")
                completion(error)
                return
            }
            // save user to CoreData!!!
            completion(nil)
        }.resume()
    }
    
    func loginUser(_ user: User, completion: @escaping (Error?) -> ()) {
        let loginUrl = baseUrl.appendingPathComponent("auth/login/")
        
        var request = URLRequest(url: loginUrl)
        
        do {
            let jsonData = try JSONEncoder().encode(user)
            request.httpBody = jsonData
        } catch {
            print("Error encoding user object: \(error)")
            completion(error)
            return
        }
        
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
                let currentUser = try JSONDecoder().decode(User.self, from: data)
                guard let token = currentUser.token,
                    let id = currentUser.id else { throw NSError() }
                self.user?.token = token
                self.user?.id = id
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
    
    func fetchAllCelebrities() {
        let celebritiesURL = baseUrl.appendingPathComponent("/celeb/")
        
        var request = URLRequest(url: celebritiesURL.usingHTTPS!)
        request.httpMethod = HTTPMethod.get
        request.setValue("application.json", forHTTPHeaderField: "Content-Type")
//        request.setValue(user?.token, forHTTPHeaderField: "Authorization")
        

        
        URLSession.shared.dataTask(with: request) { data, _, error in

            
            if let error = error {
                print("Error receiving Celebrities data: \(error)")
            }
            
            guard let data = data else {
                return
            }

            

            do {
                let decoded = try JSONDecoder().decode([Celebrity].self, from: data)
                
                _ = decoded.compactMap({ print($0.name) })
//                completion()
                return
            } catch {
                print("Error decoding [Celebrity] object: \(error)")
                
                return
            }
        }.resume()
        return
    }
    
    func addCelebrity() {
        
    }
    
    func fetchRemoteImage() {
        
    }
    
    func storeImageDataLocally() {
        
    }
    
    func fetchLocalImage() {
        
    }
}
