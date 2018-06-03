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
    
    func getEpisodes(data: Data) -> [Episode] {
        var episodes = [Episode]()
        
        let xml = SWXMLHash.parse(data)
        for item in xml["rss"]["channel"]["item"].all {
            let episode = Episode()
            if let title = item["title"].element?.text {
                episode.title = title
            }
            if let description = item["description"].element?.text {
                episode.description = description
            }
            if let description = item["description"].element?.text {
                episode.description = description
            }
            if let audioURL = item["enclosure"].element?.attribute(by: "url")?.text {
                episode.audioURL = audioURL
            }
            if let pubdateString = item["pubDate"].element?.text {
                episode.pubdate = Episode.formatter.date(from: pubdateString) ?? Date()
            }
            episodes.append(episode)
            print(episode.pubdate)
        }
        return episodes
    }
}
