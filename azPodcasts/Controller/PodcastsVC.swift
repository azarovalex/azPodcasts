//
//  PodcastsVC.swift
//  azPodcasts
//
//  Created by Alex Azarov on 5/30/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Cocoa

class PodcastsVC: NSViewController {
    
    @IBOutlet weak var podcastURLTextField: NSTextField!
    @IBOutlet weak var tableView: NSTableView!
    
    var podcasts = [Podcast]()
    var detailedVC: PodcastDetailedVC? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getPodcasts()
    }
    
    @IBAction func addPodcastClicked(_ sender: Any) {
        guard let url = URL(string: podcastURLTextField.stringValue) else { return }
        guard isPodcastExsists(withURL: url.absoluteString) == false else {
            showAlert(withAlertStyle: .critical, header: "Podcast aleready exists!", body: "There is already a podcast with the same url.")
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil, data != nil else { return }
            
            let parser = Parser()
            let info = parser.getPodcastMetaData(data: data!)
            guard info.title != nil else {
                self.showAlert(withAlertStyle: .critical, header: "Cannot open RSS file!", body: "There is an error parsing your podcast link, please, check it and try again.")
                return
            }
            
            guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
            let managedContext = appDelegate.persistentContainer.viewContext
            let podcast = Podcast(context: managedContext)
            podcast.url = url.absoluteString
            podcast.imageURL = info.imageURL
            podcast.title = info.title
            
            appDelegate.saveAction(nil)
            self.getPodcasts()
        }.resume()
        
        podcastURLTextField.stringValue = ""
    }
    
    func getPodcasts() {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        do {
            podcasts = try managedContext.fetch(fetchRequest)
            print(podcasts)
        } catch {
            print(error)
        }
        DispatchQueue.main.async(execute: {
            self.tableView.reloadData()
        })
    }
    
    
    func isPodcastExsists(withURL url: String) -> Bool {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<Podcast> = Podcast.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "url == %@", url)
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
    
    func showAlert(withAlertStyle alertStyle: NSAlert.Style, header: String, body: String) {
        let alert = NSAlert.init()
        alert.alertStyle = alertStyle
        alert.messageText = header
        alert.informativeText = body
        alert.addButton(withTitle: "OK")
        DispatchQueue.main.async {
            alert.runModal()
        }
    }
}


extension PodcastsVC: NSTableViewDelegate, NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return podcasts.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier.init("podcastCell"), owner: self) as? NSTableCellView
        let currentPodcast = podcasts[row]
        if currentPodcast.title != nil {
            cell?.textField?.stringValue = currentPodcast.title!
        } else {
            cell?.textField?.stringValue = "Unkown Title"
        }
        
        return cell
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow >= 0 else { return }
        let currentPodcast = podcasts[tableView.selectedRow]
        detailedVC?.podcast = currentPodcast
        detailedVC?.updateView()
    }
}
