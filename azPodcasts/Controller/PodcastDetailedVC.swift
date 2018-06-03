//
//  PodcastDetailedVC.swift
//  azPodcasts
//
//  Created by Alex Azarov on 5/31/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Cocoa
import AVKit

class PodcastDetailedVC: NSViewController  {
    @IBOutlet weak var avPlayerView: AVPlayerView!
    
    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var deleteButton: NSButton!
    
    var podcast: Podcast?
    weak var podcasts: PodcastsVC?
    var episodes = [Episode]()
    var player: AVPlayer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        updateView()
    }
    
    func updateView() {
        if podcast != nil {
            if podcast?.title != nil {
                titleLabel.stringValue = podcast!.title!
            } else {
                titleLabel.stringValue = ""
            }
            if podcast?.imageURL != nil {
                imageView.image = NSImage(byReferencing: URL(string: podcast!.imageURL!)!)
            } else {
                imageView.image = nil
            }
            tableView.isHidden = false
            deleteButton.isHidden = false
            titleLabel.isHidden = false
        } else {
            tableView.accessibilityParent()
            deleteButton.isHidden = true
            titleLabel.isHidden = true
        }
        
        getEpisodes()
    }
    
    func getEpisodes() {
        if podcast?.url != nil {
            if let url = URL(string: podcast!.url!) {
                URLSession.shared.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                    } else {
                        if data != nil {
                            let parser = Parser()
                            self.episodes = parser.getEpisodes(data: data!)
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                            }
                        }
                    }
                }.resume()
            }
        }
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any) {
        guard let appDelegate = NSApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if podcast != nil {
            managedContext.delete(podcast!)
            appDelegate.saveAction(self)
            podcasts?.getPodcasts()
        }
        podcast = nil
        updateView()
    }
    
}

extension PodcastDetailedVC: NSTableViewDataSource, NSTableViewDelegate {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "episodeCell"), owner: self) as? EpisodeCell {
            let episode = episodes[row]
            
            cell.titleLabel.stringValue = episode.title
            cell.descriptionLabel.stringValue = episode.description
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, yyyy"
            cell.dateLabel.stringValue = dateFormatter.string(from: episode.pubdate)
            
            return cell
        }
        return NSTableCellView()
    }
    
    func tableView(_ tableView: NSTableView, rowViewForRow row: Int) -> NSTableRowView? {
        return MyNSTableRowView()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification) {
        guard tableView.selectedRow >= 0 else { return }
        let episode = episodes[tableView.selectedRow]
        
        player?.pause()
        player = nil
        
        if let audioURL = URL(string: episode.audioURL) {
            player = AVPlayer(url: audioURL)
            avPlayerView.player = player
            
            player?.play()
        }
    }
}

class MyNSTableRowView: NSTableRowView {
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        self.isEmphasized = false
    }
}
