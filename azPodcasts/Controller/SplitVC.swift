//
//  SplitVC.swift
//  azPodcasts
//
//  Created by Alex Azarov on 5/31/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Cocoa

class SplitVC: NSSplitViewController {
    
    @IBOutlet weak var podcastsItem: NSSplitViewItem!
    @IBOutlet weak var detailedViewItem: NSSplitViewItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let podcastsVC = self.podcastsItem.viewController as? PodcastsVC,
            let detailedVC = self.detailedViewItem.viewController as? PodcastDetailedVC else { return }
        
        podcastsVC.detailedVC = detailedVC
        detailedVC.podcasts = podcastsVC        
    }
    
}
