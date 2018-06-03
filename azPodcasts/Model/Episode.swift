//
//  Episode.swift
//  azPodcasts
//
//  Created by Alex Azarov on 6/2/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Foundation

class Episode {
    var title = ""
    var pubdate = Date()
    var description = ""
    var audioURL = ""
    
    static let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss zzz"
        return formatter
    }()
}
