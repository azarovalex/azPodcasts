//
//  PodcastDetailedVC.swift
//  azPodcasts
//
//  Created by Alex Azarov on 5/31/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Cocoa

class PodcastDetailedVC: NSViewController, NSTableViewDataSource, NSTableViewDelegate  {
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var playButton: NSButton!
    
    var podcast: Podcast?
    weak var podcasts: PodcastsVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func updateView() {
        guard podcast != nil else { return }
        if podcast!.title != nil {
            titleLabel.stringValue = podcast!.title!
        } else {
            titleLabel.stringValue = ""
        }
        if podcast!.imageURL != nil {
            imageView.image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
        } else {
            imageView.image = nil
        }
        
        playButton.isHidden = true
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if podcast != nil {
            managedContext.delete(podcast!)
            appDelegate.saveAction(self)
            podcasts?.getPodcasts()
        }
        updateView()
    }
    
    @IBAction func playButtonClicked(_ sender: Any) {
        
    }
    
}
