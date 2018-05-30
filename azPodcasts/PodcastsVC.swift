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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        podcastURLTextField.stringValue = "http://feeds.soundcloud.com/users/soundcloud:users:13056021/sounds.rss"
    }
    
    @IBAction func addPodcastClicked(_ sender: Any) {
        guard let url = URL(string: podcastURLTextField.stringValue) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { print(error as Any); return }
            guard data != nil else { return }
            
            let parser = Parser()
            parser.getPodcastMetaData(data: data!)
            
            
        }.resume()
        
        podcastURLTextField.stringValue = ""
    }
}
