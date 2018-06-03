//
//  CoreDataManager.swift
//  azPodcasts
//
//  Created by Alex Azarov on 6/2/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Foundation
import CoreData

class PodcastStorage {
    
    let instance = CoreDataManager()
    
    func getPodcasts() -> [Podcast] {
        
    }
    
    func addNewPodcast(withURL url: URL) {
        
    }
    
    
    static func getPodcasts() -> [Podcast] {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            return try managedContext.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    static isPodcastExists(withURL url: String) -> Bool {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %s", url)
        do {
            let matchingPodcasts = try managedContext.fetch(fetchRequest)
            if matchingPodcasts.count >= 1 {
                return true
            } else {
                return false
            }
        } catch {
            print(error)
        }
        return false
    }
}
