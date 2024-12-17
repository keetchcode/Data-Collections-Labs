//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Wesley Keetch on 12/15/24.
//

import Foundation

struct StoreItem: Codable {
    let name: String
    let artist: String
    var kind: String
    var description: String
    var artworkURL: URL

    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case description
        case artworkURL = "artworkUrl100"
    }

    enum AdditionalKeys: CodingKey {
        case longDescription
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: CodingKeys.name)
        artist = try values.decode(String.self, forKey: CodingKeys.artist)
        kind = try values.decode(String.self, forKey: CodingKeys.kind)
        artworkURL = try values.decode(URL.self, forKey: CodingKeys.artworkURL)

        if let description = try? values.decode(String.self, forKey: CodingKeys.description) {
            self.description = description
        } else {
            let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
            description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
        }

    }

}

struct SearchResponse: Codable {
    let results: [StoreItem]
}

enum itemsError: Error, LocalizedError {
    case itemNotFound
}
