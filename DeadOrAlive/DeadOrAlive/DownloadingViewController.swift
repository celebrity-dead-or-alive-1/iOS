//
//  DownloadingViewController.swift
//  DeadOrAlive
//
//  Created by morse on 1/7/20.
//  Copyright © 2020 morse. All rights reserved.
//

import UIKit
import CoreData

class DownloadingViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    
    let networkController = NetworkController()

    override func viewDidLoad() {
        super.viewDidLoad()

//        deleteCelebs()
        fetchAllCelebrities()
    }
    
    func deleteCelebs() {
        let fetchRequest: NSFetchRequest<Celebrity> = Celebrity.fetchRequest()
        let celebs = try? CoreDataStack.shared.mainContext.fetch(fetchRequest)
        if let celebrities = celebs {
            for celeb in celebrities {
                guard let name = celeb.name else { return }
                print("Deleting \(name)")
                CoreDataStack.shared.mainContext.delete(celeb)
            }
        }
    }
    
    func fetchAllCelebrities() {
        label.text = "Fetching celebrities from the server..."
        networkController.fetchAllCelebrities { result in
            guard let representations = try? result.get() else {
                print(result)
                return
            }
            
            DispatchQueue.main.async {
                self.label.text = "Preparing celbrities for use..."
            }
            self.networkController.updateCelebrities(with: representations)
            self.fetchImages()
        }
    }
    
    func fetchImages() {
        DispatchQueue.main.async {
            self.label.text = "Fetching celebrity photos..."
        }
        let moc = CoreDataStack.shared.mainContext
        let fetchRequest: NSFetchRequest<Celebrity> = Celebrity.fetchRequest()
        let celebrities = try? moc.fetch(fetchRequest)
        DispatchQueue.main.sync {
            if let celebrities = celebrities {
                for celebrity in celebrities {
                    networkController.fetchRemoteImageData(for: celebrity)
                }
            }
        }
        try? CoreDataStack.shared.save(context: moc)
        let userDefaults = UserDefaults.standard
        userDefaults.set(true, forKey: PropertyKeys.downloadedKey)
        DispatchQueue.main.async {
         self.dismiss(animated: true, completion: nil)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
