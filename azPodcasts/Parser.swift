//
//  Parser.swift
//  azPodcasts
//
//  Created by Alex Azarov on 5/30/18.
//  Copyright © 2018 Alex Azarov. All rights reserved.
//

import Foundation
import SWXMLHash

class Parser {
    func getPodcastMetaData(data: Data) -> (title: String?, imageURL: String?) {
        let xml = SWXMLHash.parse(data)
        
        print(xml["rss"]["channel"]["title"].element?.text as Any)
        print(xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text as Any)
        
        return (xml["rss"]["channel"]["title"].element?.text, xml["rss"]["channel"]["itunes:image"].element?.attribute(by: "href")?.text)

    }
}
