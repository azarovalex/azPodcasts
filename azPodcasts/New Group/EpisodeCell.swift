//
//  EpisodeCell.swift
//  azPodcasts
//
//  Created by Alex Azarov on 6/3/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Cocoa
import WebKit

class EpisodeCell: NSTableCellView {

    @IBOutlet weak var titleLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
    @IBOutlet weak var descriptionLabel: NSTextField!
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        // Drawing code here.
    }
}
